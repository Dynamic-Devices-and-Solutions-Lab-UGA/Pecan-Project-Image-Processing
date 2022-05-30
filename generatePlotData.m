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

clear variables; % Clear variables
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

[var_out,fit,g] = getHSlice(45,'Steel',pecan_data_struct);

X = var_out(:,1);
Y = var_out(:,2);
Z = var_out(:,3);

h = plot(fit,[X Y],Z);
zlim([0 100])

legend( h, 'untitled fit 1', 'Z vs. X, Y', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'X', 'Interpreter', 'none' );
ylabel( 'Y', 'Interpreter', 'none' );
zlabel( 'Z', 'Interpreter', 'none' );
grid on



function [var,fitresult, gof] = getHSlice(angleFix,materialFix,pecan_data_struct)

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
            P(ind_start:ind_stop) = pecan_data_struct(i).test(j).post_crack_data.half(1:2).perc;
        end
        
        start_shift = start_shift+2*numel(pecan_data_struct(i).test);
    end
end

% remove zero padding
M(((ind_stop+1):end)) = [];
H(((ind_stop+1):end)) = [];
P(((ind_stop+1):end)) = [];

% find average P values
[matOut, ~, uidx] = unique([H(:), M(:)], 'rows');
avgP = accumarray(uidx, P(:), [], @mean);

% assign matrices to their proper variables
H = matOut(:,1);
M = matOut(:,2);

% find weights by taking into consideration number of tests
w = groupcounts(uidx);

% call LowessFit to get actual results
[fitresult, gof] = LowessFit(M,H,avgP,w);

% assign vars out
var = [M,H,avgP];

end

function [fitresult, gof] = LowessFit(X1,X2,X3,w)
% prepreparation of data
[xData,yData,zData,weights] = prepareSurfaceData(X1,X2,X3,w);

% Set up fittype and options.
ft = fittype('loess');
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
    [fitresult, gof] = LowessFit(E_uniq,AE_uniq,avgPE,wE);
    
    % assign vars out
    var = [E_uniq,AE_uniq,avgPE];
else
    % call LowessFit to get actual results
    [fitresult, gof] = LowessFit(V_uniq,AV_uniq,avgPV,wV);
    % assign vars out
    var = [V_uniq,AV_uniq,avgPV];
end
end