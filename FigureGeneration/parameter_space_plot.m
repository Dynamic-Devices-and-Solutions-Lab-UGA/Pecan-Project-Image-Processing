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

clear Xpatch XpatchH Ypatch YpatchM test test2

angleFix = 45;
% materialFix = 'DurableResin';
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
                % break
            end
        end
    end
end

parameterSpace_MH = flip(parameterSpace_MH,1);

% get change in Vgrid and Egrid along a single axis
dM = abs(diff(MgridcoordsSort));
% dM(end+1) = dM(end);
dM = [dM(1);dM];
dH = abs(diff(HgridcoordsSort));
% dH(end+1) = dH(end);
dH = [dH(1);dH];

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
Vgrid = ((2*g*(Hgridtrans/100)).^0.5);
Egrid = ((Mgridtrans/1000).*g.*(Hgridtrans/100));

if angleFix == 45
    %Vgrid(4,:) = (0.75*Vgrid(4,:)+0.25*Vgrid(5,:));
    %Egrid(4,:) = (0.75*Egrid(4,:)+0.25*Egrid(5,:));
end

% convert tick marks from m-h domain to v-e domains
VgridTicks = ((2*g*(HgridcoordsSort/100)).^0.5);
%EgridTicks = (MgridcoordsSort.*g.*HgridcoordsSort)/(100*1000);

% add new row and column to parameter space values
parameterSpace_VE = parameterSpace_MH;
parameterSpace_VE(end+1,:) = parameterSpace_VE(end,:);
parameterSpace_VE(:,end+1) = parameterSpace_VE(:,end);
parameterSpace_VE = rot90(parameterSpace_VE,-1);

parameterSpace_MHPatch = parameterSpace_MH;
parameterSpace_MHPatch(end+1,:) = parameterSpace_MHPatch(end,:);
parameterSpace_MHPatch(:,end+1) = parameterSpace_MHPatch(:,end);
parameterSpace_MHPatch = rot90(parameterSpace_MHPatch,-1);
Mgrid(end+1,:) = Mgrid(end,:);
Mgrid(:,end+1) = Mgrid(:,end);
Hgrid(end+1,:) = Hgrid(end,:);
Hgrid(:,end+1) = Hgrid(:,end);

if angleFix == 30 && strcmp(materialFix,'Steel')
    parameterSpace_MHPatch(parameterSpace_MHPatch>20) = parameterSpace_MHPatch(parameterSpace_MHPatch>20)/2;
    parameterSpace_VE(parameterSpace_VE>20) = parameterSpace_VE(parameterSpace_VE>20)/2;
end

for i = 1:n_H
    for j = 1:n_M
        xpatchLocalH = Hgridtrans(((i-1)+1):((i-1)+2),((j-1)+1):((j-1)+2))';
        xpatchLocal = Vgrid(((i-1)+1):((i-1)+2),((j-1)+1):((j-1)+2))';
        Xpatch{i,j} = xpatchLocal(:);
        XpatchH{i,j} = xpatchLocalH(:);
    end
end
Xpatch = Xpatch(:);
XpatchH = XpatchH(:);
for i = 1:n_H
    for j = 1:n_M
        ypatchLocalM = Mgridtrans(((i-1)+1):((i-1)+2),((j-1)+1):((j-1)+2))';
        ypatchLocalM = ypatchLocalM(:);
        ypatchLocal = Egrid(((i-1)+1):((i-1)+2),((j-1)+1):((j-1)+2))';
        ypatchLocal = ypatchLocal(:);
        Ypatch{i,j} = ypatchLocal([1;2;4;3]);
        YpatchM{i,j} = ypatchLocalM([1;2;4;3]);
    end
end
Ypatch = Ypatch(:);
YpatchM = YpatchM(:);

if strcmp(materialFix,'DurableResin')
    parameterSpace_VE = parameterSpace_VE(2:end,2:end);
    parameterSpace_MHPatch = parameterSpace_MHPatch(2:end,2:end);
else
    parameterSpace_MHPatch = parameterSpace_MHPatch(1:end-1,2:end);
    parameterSpace_VE = parameterSpace_VE(1:end-1,2:end);
end
parameterSpace_MHPatch = parameterSpace_MHPatch(:);
parameterSpace_VE = parameterSpace_VE(:);

% colors for parameter space using linspecer using a red sequence
colorsRed = linspecer(max(parameterSpace_MHPatch));

for i = 1:(n_H*n_M)
    if parameterSpace_VE(i) >= 1
        % number of tests in configuration
        counts = parameterSpace_VE(i);
        test(i) = {colorsRed(counts,:)};
    else
        test(i) = {'black'};
    end
    if parameterSpace_MHPatch(i) >= 1
        % number of tests in configuration
        counts = parameterSpace_MHPatch(i);
        test2(i) = {colorsRed(counts,:)};
    else
        test2(i) = {'black'};
    end
end

%% 

printFlag = 0;

% figure;
fontsize = 50;
patch([10 250 250 10],[100 100 1100 1100],'black')
hold on
cellfun(@patch,XpatchH,YpatchM,test2',repmat({'LineStyle'},(n_H*n_M),1),repmat({'none'},(n_H*n_M),1))
if strcmp(materialFix,'DurableResin')
    xticks(round(HgridcoordsSort(1:end-1)))
else
    xticks(round(HgridcoordsSort))
end
xtickangle(90)
yticks(round(MgridcoordsSort))
% ytickangle(45)
xlim([10 250])
ylim([100 1100])
set(gcf,'color','white')
ax = gca;
ax.FontSize = fontsize;
set(gcf,'Position',[19         145        1881         764])
xlabel('Height [cm]')
ylabel('Mass [g]')
set(gca,'TickDir','out')
cb = colorbar;
clim([0 max(parameterSpace_MHPatch)])
colormap(linspecer)
cb.Label.String = 'Number of Tests';
cb.Label.Interpreter = 'latex';
cb.Label.FontSize = fontsize;
cb.TickLabelInterpreter = 'latex';
grid on
ax = gca;
ax.GridColor = [1, 1, 1];  % [R, G, B]
ax.Layer = 'top';
if printFlag
    % store file with export_fig
    store_loc = fullfile(projectPath,'FigureGeneration\Thesis_Plots');
    filename = sprintf('Sample-ParameterSpace.MH-Material.%s-Angle.%d.pdf',materialFix,angleFix);
    export_fig(gcf,fullfile(store_loc,filename));
end


%%

set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

% figure of sampled coordinates in m-h space
h1 = figure;

imagesc(parameterSpace_MH)

colormap gray

if strcmp(materialFix,'DurableResin')
    yticks(1:5)
end

figh1 = gcf;
xTikInds = figh1.CurrentAxes.XTick;
xticklabels(round(HgridcoordsSort(xTikInds)))
yticklabels(flip(round(MgridcoordsSort)))
xlabel('Height [cm]')
ylabel('Mass [g]')
paramTitle = sprintf('Sampling of $M$-$H$ Parameter space: Material = %s,  $\\phi$  = %2d$^{\\circ}$',materialFix,angleFix);
% title(paramTitle)
set(gcf,'color','white')
% store file with export_fig
store_loc = fullfile(projectPath,'FigureGeneration\Thesis_Plots');
filename = sprintf('Sample-ParameterSpace.MH-Material.%s-Angle.%d.pdf',materialFix,angleFix);
% export_fig(h1,fullfile(store_loc,filename));
ax = gca;
ax.FontSize = 26;
set(gcf,'Position',[200 75 1400 900])

if printFlag
    % store file with export_fig
    store_loc = fullfile(projectPath,'FigureGeneration\Thesis_Plots');
    filename = sprintf('Sample-ParameterSpace.VE-Material.%s-Angle.%d.pdf',materialFix,angleFix);
    export_fig(gcf,fullfile(store_loc,filename));
end

%% 

% figure of sampled coordinates in v-e space
h2 = figure;


printFlag = 1;

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

patch(10*[0.15 0.7 0.7 0.15],[0.15 0.15 22 22],'black')
hold on
cellfun(@patch,Xpatch,Ypatch,test',repmat({'LineStyle'},(n_H*n_M),1),repmat({'none'},(n_H*n_M),1))
% cellfun(@patch,Xpatch,Ypatch,test')

if strcmp(materialFix,'DurableResin')
    xticks(round(VgridTicks(1:end-1),2))
else
    xticks(round(VgridTicks,2))
end
xtickangle(90)
yticks(2:2:19)
set(gca,'TickDir','out')
% xline(VgridTicks,'--k')
xlim(10*[0.15 0.7])
ylim([0.15 22])
if strcmp(materialFix,'Steel')&&angleFix==45
    set(gcf,'Position',[14          98        1896         820])
elseif strcmp(materialFix,'Steel')&&angleFix==30
    set(gcf,'Position',[14          98        1896         820])
elseif strcmp(materialFix,'Steel')&&angleFix==15
    set(gcf,'Position',[14          98        1896         820])
elseif strcmp(materialFix,'DurableResin')&&angleFix==30
    set(gcf,'Position',[14          98        1896         820])
end
xlabel('Velocity [m/s]','FontSize',fontsize)
ylabel('Energy [J]','FontSize',fontsize)
set(gcf,'color','white')
ax = gca;
ax.FontSize = fontsize;
grid on
ax = gca;
ax.GridColor = [1, 1, 1];  % [R, G, B]
ax.Layer = 'top';
cb = colorbar;
clim([0 max(parameterSpace_MHPatch)])
colormap(linspecer)
cb.Label.String = 'Number of Tests';
cb.Label.Interpreter = 'latex';
cb.Label.FontSize = fontsize;
cb.TickLabelInterpreter = 'latex';

if printFlag
    % store file with export_fig
    store_loc = fullfile(projectPath,'FigureGeneration\Thesis_Plots');
    filename = sprintf('Sample-ParameterSpace.VE-Material.%s-Angle.%d.pdf',materialFix,angleFix);
    export_fig(gcf,fullfile(store_loc,filename));
end


%% Closeout MATLAB

% clear; % Clear variables
% clc;  % Clear command window.
workspace;  % Make sure the workspace panel is showing.
