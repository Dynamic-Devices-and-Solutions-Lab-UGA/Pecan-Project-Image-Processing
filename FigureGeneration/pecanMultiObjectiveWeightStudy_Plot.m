%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Plot data obtained in pecanMultiObjectiveWeightStudy
%
% Author: Dani Agramonte
% Last Updated: 05.30.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialize MATLAB

% clear variables; % Clear variables

clear; % Clear variables
clc;  % Clear command window.
workspace;  % Make sure the workspace panel is showing.

% remove warning which is given if a statement is unreachable
%#ok<*UNRCH>

% Data folder
dataFolder = fullfile(projectPath,'DataPostProcessing','ParetoOptimization');

%% File variables

% print figure
printFlag = true;

% choose which file to plot
ind = 8;

%% Load in data

% get all files
files = dir(fullfile(dataFolder,'*.mat'));

% load in data - start with the first one
load(fullfile(files(1).folder,files(ind).name));

%% view angle

% generated manually
viewAngles = [-102.981594382658 20.2320767990045 58.5091442114029 28.9895253657519;...
              -124.198241513636 19.89525308087 73.1623681292005 25.284451696994;...
              -131.066940225103 19.558428718003 79.7257913423806 33.0314237555744;...
              -120.68757328333 24.9476268950347 67.9726846583138 30.3368248686648;...
              -112.750410327856 25.6212777690622 68.7358734040325 29.6631751203401;...
              -124.045603764492 18.5479514843068 75.7572098646438 30.6736497399354;...
              -133.509144211403 19.2216034854634 59.8828839536964 31.0104746303976;...
              -110.613481839844 15.516530304694 76.9783118577936 30.6736497465445];

%% Labels

zlabels = {'$\Psi(M^{\star},H^{\star}) [\%]$','$\Psi(M^{\star},H^{\star}) [\%]$','$\Psi(M^{\star},H^{\star}) [\%]$','$\Psi(M^{\star},H^{\star}) [\%]$',...
           '$\Psi(V^{\star},E^{\star}) [\%]$','$\Psi(V^{\star},E^{\star}) [\%]$','$\Psi(V^{\star},E^{\star}) [\%]$','$\Psi(V^{\star},E^{\star}) [\%]$';...
            '$\Xi(M^{\star},H^{\star}) [\%]$','$\Xi(M^{\star},H^{\star}) [\%]$','$\Xi(M^{\star},H^{\star}) [\%]$','$\Xi(M^{\star},H^{\star}) [\%]$',...
           '$\Xi(V^{\star},E^{\star}) [\%]$','$\Xi(V^{\star},E^{\star}) [\%]$','$\Xi(V^{\star},E^{\star}) [\%]$','$\Xi(V^{\star},E^{\star}) [\%]$'};

titles = {'$M-H$ Domain Pareto Front: $\phi = 15^{\circ}$, Material = Steel',...
            '$M-H$ Domain Pareto Front: $\phi = 30^{\circ}$, Material = Durable Resin',...
            '$M-H$ Domain Pareto Front: $\phi = 30^{\circ}$, Material = Steel',...
            '$M-H$ Domain Pareto Front: $\phi = 45^{\circ}$, Material = Steel',...
            '$V-E$ Domain Pareto Front: $\phi = 15^{\circ}$, Material = Steel',...
            '$V-E$ Domain Pareto Front: $\phi = 30^{\circ}$, Material = Durable Resin',...
            '$V-E$ Domain Pareto Front: $\phi = 30^{\circ}$, Material = Steel',...
            '$V-E$ Domain Pareto Front: $\phi = 45^{\circ}$, Material = Steel';...
            '$M-H$ Domain Pareto Front: $\phi = 15^{\circ}$, Material = Steel',...
            '$M-H$ Domain Pareto Front: $\phi = 30^{\circ}$, Material = Durable Resin',...
            '$M-H$ Domain Pareto Front: $\phi = 30^{\circ}$, Material = Steel',...
            '$M-H$ Domain Pareto Front: $\phi = 45^{\circ}$, Material = Steel',...
            '$V-E$ Domain Pareto Front: $\phi = 15^{\circ}$, Material = Steel',...
            '$V-E$ Domain Pareto Front: $\phi = 30^{\circ}$, Material = Durable Resin',...
            '$V-E$ Domain Pareto Front: $\phi = 30^{\circ}$, Material = Steel',...
            '$V-E$ Domain Pareto Front: $\phi = 45^{\circ}$, Material = Steel'};

outfiles = {'MHIntegrityPareto_Phi15_MaterialSteel.pdf',...
            'MHIntegrityPareto_Phi30_MaterialDurableResin.pdf',...
            'MHIntegrityPareto_Phi30_MaterialSteel.pdf',...
            'MHIntegrityPareto_Phi45_MaterialSteel.pdf',...
            'VEShellabilityPareto_Phi15_MaterialSteel.pdf',...
            'VEShellabilityPareto_Phi30_MaterialDurableResin.pdf',...
            'VEShellabilityPareto_Phi30_MaterialSteel.pdf',...
            'VEShellabilityPareto_Phi45_MaterialSteel.pdf';...
            'MHIntegrityPareto_Phi15_MaterialSteel.pdf',...
            'MHIntegrityPareto_Phi30_MaterialDurableResin.pdf',...
            'MHIntegrityPareto_Phi30_MaterialSteel.pdf',...
            'MHIntegrityPareto_Phi45_MaterialSteel.pdf',...
            'VEShellabilityPareto_Phi15_MaterialSteel.pdf',...
            'VEShellabilityPareto_Phi30_MaterialDurableResin.pdf',...
            'VEShellabilityPareto_Phi30_MaterialSteel.pdf',...
            'VEShellabilityPareto_Phi45_MaterialSteel.pdf'};

xlabels = {'$W_{(\Psi)}$','$W_{(\Psi)}$','$W_{(\Psi)}$','$W_{(\Psi)}$','$W_{(\Psi)}$','$W_{(\Psi)}$','$W_{(\Psi)}$','$W_{(\Psi)}$';...
    '$W_{(\Psi)}$','$W_{(\Psi)}$','$W_{(\Psi)}$','$W_{(\Psi)}$','$W_{(\Psi)}$','$W_{(\Psi)}$','$W_{(\Psi)}$','$W_{(\Psi)}$'};
ylabels = {'$W_{(\Xi)}$','$W_{(\Xi)}$','$W_{(\Xi)}$','$W_{(\Xi)}$','$W_{(\Xi)}$','$W_{(\Xi)}$','$W_{(\Xi)}$','$W_{(\Xi)}$';...
    '$W_{(\Xi)}$','$W_{(\Xi)}$','$W_{(\Xi)}$','$W_{(\Xi)}$','$W_{(\Xi)}$','$W_{(\Xi)}$','$W_{(\Xi)}$','$W_{(\Xi)}$'};

%% Plot

%%%%%%%%%%%%%%%%%%%
% plot initialization
%
% set font size
fontsize = 26;

% set default interpreter
set(groot,'defaultAxesTickLabelInterpreter','latex');  
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
%%%%%%%%%%%%%%%%%%%

%% Plot integrity

% create figure object
fig1 = figure;

% Create axes object
ax1 = axes('Parent',fig1);

% plot pecan integrity metric
s = surf(W1,W2,solval(:,:,1),'FaceColor','interp','FaceLighting','gouraud');

% turn off edges
s.EdgeColor = 'none';

% use Cynthia Brewer's research to make a colormap for the surface fit
colormap(linspecer);

% set axis fontsize
set(ax1,'FontSize',fontsize);

% set viewing angle
view(ax1,viewAngles(ind,1:2));

% define position vector
Position = [300, 150, 1100, 750];

% set size
set(fig1, 'Position',  Position)

% axis labels
xlabel(xlabels{1,ind},'FontSize',fontsize)
ylabel(ylabels{1,ind},'FontSize',fontsize)
zlabel(zlabels{1,ind},'FontSize',fontsize)

% set lims
xlim([min(W1(:)) max(W1(:))])
ylim([min(W2(:)) max(W2(:))])
zlim([0.98*min(min(solval(:,:,1))) max(max(solval(:,:,1)))/0.98])

% rescale colormap based off of zlims
caxis(gca,[min(min(solval(:,:,1))) max(max(solval(:,:,1)))]);

% title
title(titles{1,ind},'FontSize',fontsize)

% set background to white
set(gcf,'color','white')

%% Plot shellability

% create figure object
fig2 = figure;

% Create axes object
ax2 = axes('Parent',fig2);

% plot shellability metric
s = surf(W1,W2,solval(:,:,2),'FaceColor','interp','FaceLighting','gouraud');

% turn off edges
s.EdgeColor = 'none';

% use Cynthia Brewer's research to make a colormap for the surface fit
colormap(linspecer);

% set axis fontsize
set(ax2,'FontSize',fontsize);

% set viewing angle
view(ax2,viewAngles(ind,3:4));

% define position vector
Position = [300, 150, 1100, 750];

% set size
set(fig2, 'Position',  Position)

% axis labels
xlabel(xlabels{2,ind},'FontSize',fontsize)
ylabel(ylabels{2,ind},'FontSize',fontsize)
zlabel(zlabels{2,ind},'FontSize',fontsize)

% set lims
xlim([min(W1(:)) max(W1(:))])
ylim([min(W2(:)) max(W2(:))])
zlim([0.98*min(min(solval(:,:,2))) max(max(solval(:,:,2)))/0.98])

% rescale colormap based off of zlims
caxis(gca,[min(min(solval(:,:,2))) max(max(solval(:,:,2)))]);

% title
title(titles{2,ind},'FontSize',fontsize)

% set background to white
set(gcf,'color','white')

%% print

if printFlag
    export_fig(fig1,fullfile(figurePath,outfiles{1,ind}))
    export_fig(fig2,fullfile(figurePath,outfiles{2,ind}))
    close all;
end

% %% Closeout
% 
% clear; % Clear variables
% clc;  % Clear command window.
% workspace;  % Make sure the workspace panel is showing