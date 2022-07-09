%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Plot lowess fits
%
% Author: Dani Agramonte
% Last Updated: 07.07.22
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
dataFolder = fullfile(projectPath,'DataPostProcessing','LowessFits');

%% File variables

% print figure
printFlag = false;

% choose which file to plot 1-4: integrity, 5-8: shellability
ind = 5;

%% Load in data

% get all files
files = dir(fullfile(dataFolder,'*.mat'));

% load in data - start with the first one
load(fullfile(files(1).folder,files(ind).name));

%% view angle

viewAngles = [-34.1288536255679 30.9043700640833;...
    115.440021713069 24.4095077862583;...
    115.440021713069 24.4095077862583;...
    486.85652692134 34.1222883024068;...
    -19.5594519770671 28.0875904945666;...
    -37.2639353488214 24.4050391317879;...
    17.3104267471923 23.7514723989413;...
    -48.5107342747924 32.1831151866884];

%% Labels

zlabels = {'$\Psi(m,h) [\%]$','$\Psi(m,h)[\%]$','$\Psi(m,h)[\%]$','$\Psi(m,h)[\%]$',...
    '$\Xi(m,h)[\%]$','$\Xi(m,h)[\%]$','$\Xi(m,h)[\%]$','$\Xi(m,h)[\%]$'};

titles = {'$M-H$ Domain Lowess Fits: $\phi = 15^{\circ}$, Material = Steel',...
    '$M-H$ Domain Lowess Fits: $\phi = 30^{\circ}$, Material = Durable Resin',...
    '$M-H$ Domain Lowess Fits: $\phi = 30^{\circ}$, Material = Steel',...
    '$M-H$ Domain Lowess Fits: $\phi = 45^{\circ}$, Material = Steel',...
    '$M-H$ Domain Lowess Fits: $\phi = 15^{\circ}$, Material = Steel',...
    '$M-H$ Domain Lowess Fits: $\phi = 30^{\circ}$, Material = Durable Resin',...
    '$M-H$ Domain Lowess Fits: $\phi = 30^{\circ}$, Material = Steel',...
    '$M-H$ Domain Lowess Fits: $\phi = 45^{\circ}$, Material = Steel'};

outfiles = {'MHIntegrity_Phi15_MaterialSteel.pdf',...
    'MHIntegrity_Phi30_MaterialDurableResin.pdf',...
    'MHIntegrity_Phi30_MaterialSteel.pdf',...
    'MHIntegrity_Phi45_MaterialSteel.pdf',...
    'MHShellability_Phi15_MaterialSteel.pdf',...
    'MHShellability_Phi30_MaterialDurableResin.pdf',...
    'MHShellability_Phi30_MaterialSteel.pdf',...
    'MHShellability_Phi45_MaterialSteel.pdf'};

%% Experimental Points

% get plotting data
if ismember(ind,1:4)
    xData = var_outIntegrity(:,1);
    yData = var_outIntegrity(:,2);
    zData = var_outIntegrity(:,3);
    w1 = var_outIntegrity(:,4);
else
    xData = var_outShellability(:,1);
    yData = var_outShellability(:,2);
    zData = var_outShellability(:,3);
    w1 = var_outShellability(:,4);
end


%% Evaluate points for sfit

% domain padding factor
domPad = 0.95;

% number of points along one dimension
nPoints = 100;

% x and y vectors of spacing
xVec = linspace(min(xData)*domPad,max(xData)/domPad,nPoints);
yVec = linspace(min(yData)*domPad,max(yData)/domPad,nPoints);

% create meshgrid
[Xgrid,Ygrid] = meshgrid(xVec,yVec);

% evalute function

if ismember(ind,1:4)
    Zvals = feval(PecanMeatIntegrity_sfit,[Xgrid(:), Ygrid(:)]);
else
    Zvals = feval(PecanShellability_sfit,[Xgrid(:), Ygrid(:)]);
end

% reshape Zvals
Zvals = reshape(Zvals,nPoints,nPoints);


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

% create figure object
fig = figure;

% Create axes object
ax = axes('Parent',fig);

% plot calib surf fit
s = surf(Xgrid,Ygrid,Zvals,'FaceColor','interp','FaceLighting','gouraud');

% turn off edges
s.EdgeColor = 'none';

% use Cynthia Brewer's research to make a colormap for the surface fit
colormap(linspecer);

% set hold to on
hold(ax,'on');

% plot experimental data
scatter3(xData,yData,zData,'Marker','.','SizeData',300,'MarkerEdgeColor','k','MarkerFaceColor','k')

% set axis fontsize
set(ax,'FontSize',fontsize);

% set viewing angle
view(ax,viewAngles(ind,:));

% define position vector
Position = [300, 150, 1100, 750];

% set size
set(fig, 'Position',  Position)

% axis labels
xlabel('mass [g]','FontSize',fontsize)
ylabel('height [cm]','FontSize',fontsize)
zlabel(zlabels{ind},'FontSize',fontsize)

% set lims
xlim([min(Xgrid(:)) max(Xgrid(:))])
ylim([min(Ygrid(:)) max(Ygrid(:))])
zlim([0 110])

% rescale colormap based off of zlims
caxis(gca,[0 110]);

% title
title(titles{ind},'FontSize',fontsize)

% set background to white
set(gcf,'color','white')

% turn off hold
hold(ax,'off');

if printFlag
    export_fig(gcf,fullfile(figurePath,outfiles{ind}))
    close all;
end

%% Closeout

clear; % Clear variables
clc;  % Clear command window.
workspace;  % Make sure the workspace panel is showing.

