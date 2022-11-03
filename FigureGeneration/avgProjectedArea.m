%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Find useful averages
%
%
% Author: Dani Agramonte
% Last Updated: 09.25.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialize MATLAB

clear variables; % Clear variables
workspace;  % Make sure the workspace panel is showing.
commandwindow();

% set path of where data is located
data_path = fullfile(projectPath,'DataProcessing\Pecan_Data_Master\pecan_data_struct.mat');

%#ok<*SAGROW> 

load(data_path)

%% Calculate averages

pre_crack_area = [];
post_crack_area = [];
intAgg = [];
shellAgg = [];
for i = 1:length(pecan_data_struct)
    for j = 1:length(pecan_data_struct(i).test)
        pre_crack_area = [pre_crack_area; pecan_data_struct(i).test(j).pre_crack_data.pre_crack_area]; %#ok<AGROW>
        post_crack_area = [post_crack_area; transpose([pecan_data_struct(i).test(j).post_crack_data.half(1:2).post_crack_area])]; %#ok<AGROW>
        intAgg = [intAgg; transpose([pecan_data_struct(i).test(j).post_crack_data.half(1:2).perc])]; %#ok<AGROW>
        shellAgg = [shellAgg; transpose(100*ceil([pecan_data_struct(i).test(j).post_crack_data.half(1:2).perc]./100))]; %#ok<AGROW>
    end
end

% calculate average 
avg_pre_crack_area = mean(pre_crack_area);

% calculate standard deviation
std_pre_crack_area = std(pre_crack_area);

%% Calculate averages across angles

% angles of consideration
angleFix = [15,30,45];
materialFix = {'Steel','DurableResin'};

% combinations
% [angleFix, materialFix]
combs = [...
    1 1;...
    2 1;...
    3 1;...
    2 2];

coordSys = 'MH';

opts1.type = 'P';
opts1.coordSys = coordSys;

opts2.type = 'S';
opts2.coordSys = coordSys;

% initialize average integrity and shellability matrices
avgInt = zeros(size(combs,1),1);
avgShell = zeros(size(combs,1),1);

for i = 1:size(combs,1)
    % get fits
    avgInt(i) = getHSlice(angleFix(combs(i,1)),materialFix{combs(i,2)},pecan_data_struct,opts1);
    avgShell(i) = getHSlice(angleFix(combs(i,1)),materialFix{combs(i,2)},pecan_data_struct,opts2);
end

%% Plot

% set print flag
printFlag = 1;

% set default interpreter
set(groot,'defaultAxesTickLabelInterpreter','latex');  
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

% set font size
fontsize = 20;

% get matrix of blue colors
BlueColors = linspecer(3,'blue');

% plot post crack area
figure;
histogram(post_crack_area(post_crack_area>0),...
    'FaceColor',BlueColors(2,:),'FaceAlpha',1);
hold on;
xline(mean(post_crack_area(post_crack_area>0)),'k--','mean($A_{o}$)',...
    'LabelHorizontalAlignment','center','LabelVerticalAlignment','top',...
    'Interpreter','latex','FontSize',fontsize);

colormap linspecer;
xlabel('Post Crack Area [mm\textsuperscript{2}]','FontSize',fontsize);
ylabel('Number of Tests','FontSize',fontsize);
set(gcf,'color','white');
ax = gca;
ax.FontSize = fontsize;
set(gcf,'Position',[384   299   849   599])

if printFlag
    export_fig(gcf,fullfile(figurePath,'PostCrackAreaDist.pdf')) 
end

% plot pre crack area
figure;
histogram(pre_crack_area,'FaceColor',BlueColors(2,:),'FaceAlpha',1);
hold on;
xline(mean(pre_crack_area),'k--','mean($A_{r}$)',...
    'LabelHorizontalAlignment','left','LabelVerticalAlignment','top',...
    'Interpreter','latex','FontSize',fontsize)
colormap linspecer;
xlabel('Pre Crack Area [mm\textsuperscript{2}]','FontSize',fontsize);
ylabel('Number of Tests','FontSize',fontsize);
set(gcf,'color','white');
ax = gca;
ax.FontSize = fontsize;
set(gcf,'Position',[384   299   849   599])

if printFlag
    export_fig(gcf,fullfile(figurePath,'PreCrackAreaDist.pdf')) 
end

% plot pecan integrity
figure;
histogram(intAgg(intAgg>0),'FaceColor',BlueColors(2,:),'FaceAlpha',1);
hold on;
xline(mean(intAgg(intAgg>0)),'k--','mean($\Psi$)',...
    'LabelHorizontalAlignment','left','LabelVerticalAlignment','top',...
    'Interpreter','latex','FontSize',fontsize);
colormap linspecer;
xlabel('Pecan Integrity [\%]','FontSize',fontsize);
ylabel('Number of Tests','FontSize',fontsize);
set(gcf,'color','white');
ax = gca;
ax.FontSize = fontsize;
set(gcf,'Position',[384   299   849   599])

if printFlag
    export_fig(gcf,fullfile(figurePath,'PecanIntegrityDist.pdf')) 
end

% plot shellability with bar graph
figure;
bar([0 100],[sum(shellAgg == 0) sum(shellAgg == 100)],...
    'FaceColor',BlueColors(2,:),'FaceAlpha',1)
colormap linspecer;
xlabel('Pecan Shellability [\%]','FontSize',fontsize);
ylabel('Number of Tests','FontSize',fontsize);
set(gcf,'color','white');
xlim([-50 150])
ax = gca;
ax.FontSize = fontsize;
set(gcf,'Position',[384   299   849   599])

if printFlag
    export_fig(gcf,fullfile(figurePath,'ShellabillityDist.pdf')) 
end


%---- END MAIN SCRIPT ----%

function avgVal = getHSlice(angleFix,materialFix,pecan_data_struct,opts)

if strcmp(opts.type,'S')
    param.type = 0;
elseif strcmp(opts.type,'P')
    param.type = 1;
else
    error('Invalid value for ''opts''')
end

if strcmp(opts.coordSys,'MH')
    param.coordSys = 0;
elseif strcmp(opts.coordSys,'VE')
    param.coordSys = 1;
else
    error('Invalid value for ''opts''')
end

% valid angles
validAngles = [15 30 45];

% ensure valid angle
if ~ismember(angleFix,validAngles)
    error('invalid value for angleFix')
end

% check materialFix
if ~(strcmp(materialFix,'Steel')||strcmp(materialFix,'DurableResin'))
    error('invalid value for materialFix')
end

% initialize variables
M = zeros(5e4,1);
H = zeros(5e4,1);
P = zeros(5e4,1);
S = zeros(5e4,1);

% extract from datastructure
start_shift = 0;
for i = 1:numel(pecan_data_struct)
    if (pecan_data_struct(i).metadata.Angle == angleFix) && ...
            (strcmp(pecan_data_struct(i).metadata.Material,materialFix))
        for j = 1:numel(pecan_data_struct(i).test)
            
            % calculate start and stop indices
            ind_start = start_shift+2*(j-1)+1;
            ind_stop = start_shift+2*(j-1)+2;
            
            % set values
            M(ind_start:ind_stop) = pecan_data_struct(i).metadata.Mass;
            H(ind_start:ind_stop) = pecan_data_struct(i).metadata.Height;
            P(ind_start:ind_stop) = [pecan_data_struct(i).test(j).post_crack_data.half(1:2).perc];
            S(ind_start:ind_stop) = 100*ceil([pecan_data_struct(i).test(j).post_crack_data.half(1:2).perc]./100);
        end
        
        start_shift = start_shift+2*numel(pecan_data_struct(i).test);
    end
end

% remove zero padding
M(((ind_stop+1):end)) = [];
H(((ind_stop+1):end)) = [];
P(((ind_stop+1):end)) = [];
S(((ind_stop+1):end)) = [];

if param.type
    
    % delete zero values
    H(P == 0) = [];
    M(P == 0) = [];
    P(P == 0) = [];
    
    % find average P values
    [~, ~, uidx] = unique([H(:),M(:)], 'rows');
    avgP = accumarray(uidx, P(:), [], @mean);

    % calculate average
    avgVal = mean(avgP);
else
    [~, ~, uidx] = unique([H(:),M(:)], 'rows');
    avgS = accumarray(uidx, S(:), [], @mean);

    % calculate average
    avgVal = mean(avgS);
end
end