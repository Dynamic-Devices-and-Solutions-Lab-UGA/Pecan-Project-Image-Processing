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
data_path = fullfile(projectPath,'DataProcessing\Pecan_Data_Master\pecan_data_struct.mat');

%#ok<*SAGROW> 

load(data_path)

%% plot data

angleFix = 30;
materialFix = 'DurableResin';

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
dM = abs(diff(MgridcoordsSort));
dM(end+1) = dM(end);
dH = abs(diff(HgridcoordsSort));
dH(end+1) = dH(end);

% make meshgrid of original coordinate space
[Mgrid, Hgrid] = meshgrid(MgridcoordsSort,HgridcoordsSort);

% gravitational constant
g = 9.8;

% shift grid by a half unit
Mgridtrans = Mgrid-(dM'/2).*ones(size(Mgrid));
Hgridtrans = Hgrid-(dH/2).*ones(size(Hgrid));

% add new row and column to Vgrid and Egrid
Mgridtrans(:,end+1) = dM(end)+Mgridtrans(:,end);
Mgridtrans(end+1,:) = Mgridtrans(end,:);
Hgridtrans(end+1,:) = dH(end)+Hgridtrans(end,:);
Hgridtrans(:,end+1) = Hgridtrans(:,end);

% convert grid from m-h domain to v-e domain
Vgrid = ((2*g*Hgridtrans).^0.5)/(100);
Egrid = (Mgridtrans.*g.*Hgridtrans)/(100*1000);

if angleFix == 45
    %Vgrid(4,:) = (0.75*Vgrid(4,:)+0.25*Vgrid(5,:));
    %Egrid(4,:) = (0.75*Egrid(4,:)+0.25*Egrid(5,:));
end

% convert tick marks from m-h domain to v-e domains
VgridTicks = ((2*g*HgridcoordsSort).^0.5)/(100);
%EgridTicks = (MgridcoordsSort.*g.*HgridcoordsSort)/(100*1000);

% add new row and column to parameter space values
parameterSpace_VE = rot90(parameterSpace_MH,-1);
parameterSpace_VE(end+1,:) = parameterSpace_VE(end,:);
parameterSpace_VE(:,end+1) = parameterSpace_VE(:,end);

for i = 1:14
    for j = 1:5
        xpatchLocal = Vgrid(((i-1)+1):((i-1)+2),((j-1)+1):((j-1)+2))';
        Xpatch{i,j} = xpatchLocal(:);
    end
end
Xpatch = Xpatch(:);
for i = 1:14
    for j = 1:5
        ypatchLocal = Egrid(((i-1)+1):((i-1)+2),((j-1)+1):((j-1)+2))';
        ypatchLocal = ypatchLocal(:);
        Ypatch{i,j} = ypatchLocal([1;2;4;3]);
    end
end
Ypatch = Ypatch(:);

parameterSpace_VE = parameterSpace_VE(1:14,1:5);
parameterSpace_VE = parameterSpace_VE(:);
for i = 1:70
    if parameterSpace_VE(i) == 1
        test(i) = {'white'};
    else
        test(i) = {'black'};
    end
end

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
store_loc = fullfile(projectPath,'FigureGeneration\Thesis_Plots');
filename = sprintf('Sample-ParameterSpace.MH-Material.%s-Angle.%d.pdf',materialFix,angleFix);
export_fig(h1,fullfile(store_loc,filename));

% figure of sampled coordinates in v-e space
h2 = figure;

%{
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
%}

set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
patch([0.15 0.7 0.7 0.15],[0.15 0.15 19 19],'black')
hold on
cellfun(@patch,Xpatch,Ypatch,test',repmat({'LineStyle'},70,1),repmat({'none'},70,1))
% cellfun(@patch,Xpatch,Ypatch,test')
xticks(VgridTicks)
if strcmp(materialFix,'Steel')&&angleFix==15
    xticks(VgridTicks(1:10))
end
yticks(2:2:19)
set(gca,'TickDir','out')
% xline(VgridTicks,'--k')
xlim([0.15 0.7])
ylim([0.15 19])
if strcmp(materialFix,'Steel')&&angleFix==45
    set(gcf,'Position',[200 75 1400 900])
elseif strcmp(materialFix,'Steel')&&angleFix==30
    set(gcf,'Position',[200 75 1400 900])
elseif strcmp(materialFix,'Steel')&&angleFix==15
    set(gcf,'Position',[200 75 1400 900])
elseif strcmp(materialFix,'DurableResin')&&angleFix==30
    set(gcf,'Position',[200 75 1400 900])
end
xlabel('Velocity [m/s]','FontSize',26)
ylabel('Energy [J]','FontSize',26)
set(gcf,'color','white')
ax = gca;
ax.FontSize = 26;

% store file with export_fig
store_loc = fullfile(projectPath,'FigureGeneration\Thesis_Plots');
filename = sprintf('Sample-ParameterSpace.VE-Material.%s-Angle.%d.pdf',materialFix,angleFix);
export_fig(gcf,fullfile(store_loc,filename));


%% Closeout MATLAB

% clear; % Clear variables
% clc;  % Clear command window.
workspace;  % Make sure the workspace panel is showing.
