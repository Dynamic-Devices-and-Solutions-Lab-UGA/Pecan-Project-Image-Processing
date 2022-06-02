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
Mgridcoords = unique(M,'stable');
Hgridcoords = unique(H,'stable');

configParams = [M H];

% sort
MgridcoordsSort = sort(Mgridcoords);
HgridcoordsSort = sort(Hgridcoords);

% initialize parameter space in m-h coordinates
parameterSpace_MH = zeros(numel(Mgridcoords),numel(Hgridcoords));

% get size of parameter space
[n_M,n_H] = size(parameterSpace_MH);

% get spaces in parameter space
for i = 1:n_M
    for j = 1:n_H
        pair = [MgridcoordsSort(i),HgridcoordsSort(j)];
        for k = 1:numel(M)
            if isequal(pair,configParams(k,:))
                parameterSpace_MH(i,j) = parameterSpace_MH(i,j)+1;
                break
            end
        end
    end
end

% get change in Vgrid and Egrid along a single axis
dM = (MgridcoordsSort(2)-MgridcoordsSort(1));
dH = (HgridcoordsSort(2)-HgridcoordsSort(1));

% make meshgrid of original coordinate space
[Mgrid, Hgrid] = meshgrid(MgridcoordsSort,HgridcoordsSort);

% gravitational constant
g = 9.8;

% shift grid by a half unit
Mgridtrans = Mgrid-dM/2;
Hgridtrans = Hgrid-dH/2;

% add new row and column to Vgrid and Egrid
Mgridtrans(:,end+1) = dM+Mgridtrans(:,end);
Mgridtrans(end+1,:) = Mgridtrans(end,:);
Hgridtrans(end+1,:) = dH+Hgridtrans(end,:);
Hgridtrans(:,end+1) = Hgridtrans(:,end);

% convert grid from m-h domain to v-e domain
Vgrid = ((2*g*Hgridtrans).^0.5)/(100);
Egrid = (Mgridtrans.*g.*Hgridtrans)/(100*1000);

% convert tick marks from m-h domain to v-e domains
VgridTicks = ((2*g*HgridcoordsSort).^0.5)/(100);
%EgridTicks = (MgridcoordsSort.*g.*HgridcoordsSort)/(100*1000);

% add new row and column to parameter space values
parameterSpace_VE = rot90(parameterSpace_MH,-1);
parameterSpace_VE(end+1,:) = parameterSpace_VE(end,:);
parameterSpace_VE(:,end+1) = parameterSpace_VE(:,end);

% figure of sampled coordinates in m-h space
h1 = figure;

imagesc(parameterSpace_MH)

colormap gray

if strcmp(materialFix,'DurableResin')
    yticks(1:5)
end

xticklabels(HgridcoordsSort)
yticklabels(MgridcoordsSort)
xlabel('Height [cm]')
ylabel('Mass [g]')
paramTitle = sprintf('Sampling of $M$-$H$ Parameter space: Material = %s,  $\\phi$  = %2d$^{\\circ}$',materialFix,angleFix);
title(paramTitle)
set(gcf,'color','white')
% store file with export_fig
store_loc = 'C:\Users\Dani\Documents\Pecan-Project-Image-Processing\Figures';
filename = sprintf('Sample-ParameterSpace.MH-Material.%s-Angle.%d.eps',materialFix,angleFix);
export_fig(h1,fullfile(store_loc,filename));

% figure of sampled coordinates in v-e space
h2 = figure;

surf(Vgrid,Egrid,parameterSpace_VE)
colormap gray
xticks(VgridTicks)
xlim([min(min(Vgrid)) max(max(Vgrid))]);
ylim([min(min(Egrid)) max(max(Egrid))]);
paramTitle = sprintf('Sampling of $V$-$E$ Parameter space: Material = %s,  $\\phi$  = %2d$^{\\circ}$',materialFix,angleFix);
title(paramTitle)
set(gcf,'color','white')
xlabel('Velocity [m/s]')
ylabel('Energy [J]')
view(gca,[0 90]);
grid off
box on
% store file with export_fig
store_loc = 'C:\Users\Dani\Documents\Pecan-Project-Image-Processing\Figures';
filename = sprintf('Sample-ParameterSpace.VE-Material.%s-Angle.%d.eps',materialFix,angleFix);
export_fig(h2,fullfile(store_loc,filename));


%% Closeout MATLAB

% clear; % Clear variables
% clc;  % Clear command window.
workspace;  % Make sure the workspace panel is showing.
