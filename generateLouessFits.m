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
data_path = ['C:\Users\Dani\Documents\Pecan-Project-Image-Processing\'...
    'Pecan_Data_Master\pecan_data_struct.mat'];

load(data_path)

%% plot data

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            Angle - 15, Material - Steel                                         %
%                                                                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

angleFix = 30;
materialFix = 'Steel';

% get fits
[var_out1,PecanMeatIntegrity_sfit,g1] = getHSlice(angleFix,materialFix,pecan_data_struct,'P');
[var_out2,PecanShellability_sfit,g2] = getHSlice(angleFix,materialFix,pecan_data_struct,'S');

% data for opts = 'P'
X1 = var_out1(:,1);
Y1 = var_out1(:,2);
Z1 = var_out1(:,3);
w1 = var_out1(:,4);

% data for opts = 'S' 
X2 = var_out2(:,1);
Y2 = var_out2(:,2);
Z2 = var_out2(:,3);
w2 = var_out2(:,4);

h1 = figure;
plot(PecanMeatIntegrity_sfit,[X1 Y1],Z1);

% set background to white
set(gcf,'color','white')

% specify zlimits
zlim([0 105])

% specify colormap
colormap(jet)

% Label axes
xlabel('Mass $[g]$');
ylabel('Height $[cm]$');
zlabel('Pecan Integrity, $\Psi [\%]$');

% specify title


% turn grid on
grid on

h2 = figure;

% plot surface
plot(PecanShellability_sfit,[X2 Y2],Z2);

% set background to white
set(gcf,'color','white')

% specify zlimits
zlim([0 105])

% specify colormap
colormap(jet)

% Label axes
xlabel('Mass $[g]$');
ylabel('Height $[cm]$');
zlabel('Pecan Shellability, $\Xi [\%]$');

% turn grid on
grid on

% calculate upper and lower bounds for m and
lb = [min(X1), min(Y1)];
ub = [max(X1), max(Y1)];

% home folder
folder_loc = 'C:\Users\Dani\Documents\Pecan-Project-Image-Processing\Pecan_Surface_Fits';

% file name
name = sprintf('PecanSurfaceFits-Angle.%d-Material.%s.mat',angleFix,materialFix);

% save data
save(fullfile(folder_loc,name),'PecanMeatIntegrity_sfit','PecanShellability_sfit','lb','ub')



function [var,fitresult,gof] = getHSlice(angleFix,materialFix,pecan_data_struct,opts)

if strcmp(opts,'S')
    param = 0;
elseif strcmp(opts,'P')
    param = 1;
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

if param
    
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
H = matOut(:,1);
M = matOut(:,2);

% find weights by taking into consideration number of tests
w = groupcounts(uidx);

if param
    % call LowessFit to get actual results
    [fitresult, gof] = LouessFit(M,H,avgP,w,'lowess');
    
    % assign vars out
    var = [M,H,avgP,w];
else
    % call LowessFit to get actual results
    [fitresult, gof] = LouessFit(M,H,avgS,w,'loess');
    
    % assign vars out
    var = [M,H,avgS,w];
end
end

function [fitresult, gof] = LouessFit(X1,X2,X3,w,opts)

if ~(strcmp(opts,'loess')||strcmp(opts,'lowess'))
    error('Invalid value for ''opts''')
end

% prepreparation of data
[xData,yData,zData,weights] = prepareSurfaceData(X1,X2,X3,w);

% Set up fittype and options.
ft = fittype(opts);
opts = fitoptions('Method','LowessFit');
opts.Normalize = 'on';
opts.Robust = 'Bisquare';
opts.Span = 0.75;
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

function [var,fitresult, gof] = getVSlice(coordFix,pecan_data_struct)

switch coordFix
    case {'v','velocity'}
        flag = 0;
    case {'e','energy'}
        flag = 1;
    otherwise
        error('invalid value for coordFix')
end

% set fixed material - unfortunately we don't have enough data 
% to properly compare durable resin and steel
materialFix = 'Steel';

% initialize variables
M = zeros(5e4,1);
H = zeros(5e4,1);
P = zeros(5e4,1);
A = zeros(5e4,1);
S = zeros(5e4,1);

% possible set of angles
angleSet = [15,30,45];

% extract from datastructure
start_shift = 0;
for k = 1:3
    angleLoc = angleSet(k);
    for i = 1:numel(pecan_data_struct)
        if (pecan_data_struct(i).metadata.Angle == angleLoc) && ...
                (strcmp(pecan_data_struct(i).metadata.Material,materialFix))
            for j = 1:numel(pecan_data_struct(i).test)

                % calculate start and stop indices
                ind_start = start_shift+2*(j-1)+1;
                ind_stop = start_shift+2*(j-1)+2;

                % set values
                M(ind_start:ind_stop) = pecan_data_struct(i).metadata.Mass;
                H(ind_start:ind_stop) = pecan_data_struct(i).metadata.Height;
                P(ind_start:ind_stop) = pecan_data_struct(i).test(j).post_crack_data.half(1:2).perc;
                S(ind_start:ind_stop) = 100*ceil(pecan_data_struct(i).test(j).post_crack_data.half(1:2).perc/100);
                A(ind_start:ind_stop) = pecan_data_struct(i).metadata.Angle;
            end

            start_shift = start_shift+2*numel(pecan_data_struct(i).test);
        end
    end
end

% remove zero padding
M(((ind_stop+1):end)) = [];
H(((ind_stop+1):end)) = [];
P(((ind_stop+1):end)) = [];
A(((ind_stop+1):end)) = [];
S(((ind_stop+1):end)) = [];

% tranformed coordate system
[V,E] = coordTrans(M,H);

% find average P values
[EA_uniq, ~, uidxE] = unique([E(:), A(:)], 'rows');
avgPE = accumarray(uidxE, P(:), [], @mean);

E_uniq = EA_uniq(:,1);
AE_uniq = EA_uniq(:,2);

% find weights by taking into consideration number of tests
wE = groupcounts(uidx);

% find average P values
[VA_uniq, ~, uidxV] = unique([V(:), A(:)], 'rows');
avgPV = accumarray(uidxV, P(:), [], @mean);

V_uniq = VA_uniq(:,1);
AV_uniq = VA_uniq(:,2);

% find weights by taking into consideration number of tests
wV = groupcounts(uidxV);

if flag
    % call LowessFit to get actual results
    [fitresult, gof] = LouessFit(E_uniq,AE_uniq,avgPE,wE);
    
    % assign vars out
    var = [E_uniq,AE_uniq,avgPE];
else
    % call LowessFit to get actual results
    [fitresult, gof] = LouessFit(V_uniq,AV_uniq,avgPV,wV);
    % assign vars out
    var = [V_uniq,AV_uniq,avgPV];
end
end