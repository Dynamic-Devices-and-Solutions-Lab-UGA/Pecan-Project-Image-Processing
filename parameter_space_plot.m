%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Plot which points in the parameter space were sampled
%
%
% Author: Dani Agramonte
% Last Updated: 05.30.22
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

angleFix = 45;
materialFix = 'Steel';

M = zeros(5e4,1);
H = zeros(5e4,1);

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
        end
        
        start_shift = start_shift+2*numel(pecan_data_struct(i).test);
    end
end

% remove zero padding
M(((ind_stop+1):end)) = [];
H(((ind_stop+1):end)) = [];

% get unique values
M_grid = unique(M,'stable');
H_grid = unique(H,'stable');

configParams = [M H];

% sort
M_grid_s = sort(M_grid);
H_grid_s = sort(H_grid);

% initialize parameter space
parameter_space = zeros(numel(M_grid),numel(H_grid));

% get size of parameter space
[n_M,n_H] = size(parameter_space);

for i = 1:n_M
    for j = 1:n_H
        pair = [M_grid_s(i),H_grid_s(j)];
        for k = 1:numel(M)
            if isequal(pair,configParams(k,:))
                parameter_space(i,j) = parameter_space(i,j)+1;
                break
            end
        end
    end
end

imagesc(parameter_space)

colormap gray

xticklabels(H_grid_s)
yticklabels(M_grid_s)
xlabel('Height [cm]')
ylabel('Mass [g]')
paramTitle = sprintf('Sampling of Parameter space: Material = %s,  $\\phi$  = %2d$^{\\circ}$',materialFix,angleFix);
title(paramTitle)
set(gcf,'color','white')


