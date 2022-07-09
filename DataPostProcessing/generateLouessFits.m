%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Create plot data from pecan_data_struct 
%
%
% Author: Dani Agramonte
% Last Updated: 05.29.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialize MATLAB

%clear variables; % Clear variables
workspace;  % Make sure the workspace panel is showing.
commandwindow();

% set path of where data is located
data_path = fullfile(projectPath,'DataProcessing\Pecan_Data_Master\pecan_data_struct.mat');

load(data_path)

%% Generate sfits

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


for i = 1:size(combs,1)
    % get fits
    [var_outIntegrity,PecanMeatIntegrity_sfit,gIntegrity] = getHSlice(angleFix(combs(i,1)),materialFix{combs(i,2)},pecan_data_struct,opts1);
    [var_outShellability,PecanShellability_sfit,gShellability] = getHSlice(angleFix(combs(i,1)),materialFix{combs(i,2)},pecan_data_struct,opts2);

    % generate names
    namePMI = fullfile(projectPath,'DataPostProcessing','LowessFits',sprintf([coordSys,'PecanMeatIntegrityFit_%.f_%s.mat'],angleFix(combs(i,1)),materialFix{combs(i,2)}));
    nameShell = fullfile(projectPath,'DataPostProcessing','LowessFits',sprintf([coordSys,'ShellabilityFit_%.f_%s.mat'],angleFix(combs(i,1)),materialFix{combs(i,2)}));

    % save variables
    save(namePMI,'var_outIntegrity','PecanMeatIntegrity_sfit','gIntegrity')
    save(nameShell,'var_outShellability','PecanShellability_sfit','gShellability')
end

clear;

%---- END MAIN SCRIPT ----%

function [var,fitresult,gof] = getHSlice(angleFix,materialFix,pecan_data_struct,opts)

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
    [matOut, ~, uidx] = unique([H(:),M(:)], 'rows');
    avgP = accumarray(uidx, P(:), [], @mean);
else
    [matOut, ~, uidx] = unique([H(:),M(:)], 'rows');
    avgS = accumarray(uidx, S(:), [], @mean);
end

% assign matrices to their proper variables
var1 = matOut(:,1); % V normally
var2 = matOut(:,2); % M normally

if param.coordSys
    [var1,var2] = coordTrans(var1,var2);
    % var1 = V
    % var2 = E
else
    [var1,var2] = coordTrans2(var1,var2);
end

% find weights by taking into consideration number of tests
w = groupcounts(uidx);

if param.type
    % call LowessFit to get actual results
    [fitresult, gof] = LouessFit(var2,var1,avgP,w,'lowess',param);
    
    % assign vars out
    var = [var2,var1,avgP,w];
else
    % call LowessFit to get actual results
    [fitresult, gof] = LouessFit(var2,var1,avgS,w,'loess',param);
    
    % assign vars out
    var = [var2,var1,avgS,w];
end
end

function [fitresult, gof] = LouessFit(X1,X2,X3,w,opts,param)

if ~(strcmp(opts,'loess')||strcmp(opts,'lowess'))
    error('Invalid value for ''opts''')
end

% prepreparation of data
[xData,yData,zData,weights] = prepareSurfaceData(X1,X2,X3,w);

% Set up fittype and options.
ft = fittype(opts);
opts = fitoptions('Method','LowessFit');
opts.Normalize = 'on';
if ~param.coordSys
    opts.Robust = 'Bisquare';
    opts.Span = 0.75;
else
    opts.Span = 0.75;
end
opts.Weights = weights;

% Fit model to data.
[fitresult, gof] = fit([xData,yData],zData,ft,opts);
end

function [V,E] = coordTrans(M,H)

% apply quadratic transfrom to get from mass-height coords to 
% velocity-energy coordinates
g = 9.8;
V = (2*g*(H/100)).^0.5;
E = g*(M/1000).*(H/100);

end

function [H,M] = coordTrans2(H,M)
% shift M and H to m and kg
M = M/1000;
H = H/100;
end