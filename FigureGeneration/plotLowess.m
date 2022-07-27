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
printFlag = true;

% choose which file to plot 1-4: integrity, 5-8: shellability
ind = 1;

%% Load in data

% get all files
files = dir(fullfile(dataFolder,'*.mat'));

% load in data - start with the first one
load(fullfile(files(1).folder,files(ind).name));

%% view angle

% generated manually
viewAngles = [-34.1288536255679 30.9043700640833;...
                115.440021713069 24.4095077862583;...
                115.440021713069 24.4095077862583;...
                486.85652692134 34.1222883024068;...
                -19.5594519770671 28.0875904945666;...
                -37.2639353488214 24.4050391317879;...
                17.3104267471923 23.7514723989413;...
                -48.5107342747924 32.1831151866884;...
                -33.3787807568528 24.6108019546176;...
                129.180414986578 27.6422259172948;...
                139.559789812354 39.4310965850893;...
                140.475626696794 41.452046201464;...
                -57.9347654528694 37.4200863794762;...
                -14.299063118302 38.0837968824855;...
                -48.0320047027382 35.0523731741957;...
                -15.3675249755048 37.073322646788];

%% Labels

zlabels = {'$\Psi(M,H) [\%]$','$\Psi(M,H)[\%]$','$\Psi(M,H)[\%]$','$\Psi(M,H)[\%]$',...
            '$\Xi(M,H)[\%]$','$\Xi(M,H)[\%]$','$\Xi(M,H)[\%]$','$\Xi(M,H)[\%]$',...
            '$\Psi(V,E) [\%]$','$\Psi(V,E)[\%]$','$\Psi(V,E)[\%]$','$\Psi(V,E)[\%]$',...
            '$\Xi(V,E)[\%]$','$\Xi(V,E)[\%]$','$\Xi(V,E)[\%]$','$\Xi(V,E)[\%]$'};

titles = {'$M-H$ Domain Lowess Fits: $\phi = 15^{\circ}$, Material = Steel',...
            '$M-H$ Domain Lowess Fits: $\phi = 30^{\circ}$, Material = Durable Resin',...
            '$M-H$ Domain Lowess Fits: $\phi = 30^{\circ}$, Material = Steel',...
            '$M-H$ Domain Lowess Fits: $\phi = 45^{\circ}$, Material = Steel',...
            '$M-H$ Domain Lowess Fits: $\phi = 15^{\circ}$, Material = Steel',...
            '$M-H$ Domain Lowess Fits: $\phi = 30^{\circ}$, Material = Durable Resin',...
            '$M-H$ Domain Lowess Fits: $\phi = 30^{\circ}$, Material = Steel',...
            '$M-H$ Domain Lowess Fits: $\phi = 45^{\circ}$, Material = Steel',...
            '$V-E$ Domain Lowess Fits: $\phi = 15^{\circ}$, Material = Steel',...
            '$V-E$ Domain Lowess Fits: $\phi = 30^{\circ}$, Material = Durable Resin',...
            '$V-E$ Domain Lowess Fits: $\phi = 30^{\circ}$, Material = Steel',...
            '$V-E$ Domain Lowess Fits: $\phi = 45^{\circ}$, Material = Steel',...
            '$V-E$ Domain Lowess Fits: $\phi = 15^{\circ}$, Material = Steel',...
            '$V-E$ Domain Lowess Fits: $\phi = 30^{\circ}$, Material = Durable Resin',...
            '$V-E$ Domain Lowess Fits: $\phi = 30^{\circ}$, Material = Steel',...
            '$V-E$ Domain Lowess Fits: $\phi = 45^{\circ}$, Material = Steel'};

outfiles = {'MHIntegrity_Phi15_MaterialSteel.pdf',...
            'MHIntegrity_Phi30_MaterialDurableResin.pdf',...
            'MHIntegrity_Phi30_MaterialSteel.pdf',...
            'MHIntegrity_Phi45_MaterialSteel.pdf',...
            'MHShellability_Phi15_MaterialSteel.pdf',...
            'MHShellability_Phi30_MaterialDurableResin.pdf',...
            'MHShellability_Phi30_MaterialSteel.pdf',...
            'MHShellability_Phi45_MaterialSteel.pdf',...
            'VEIntegrity_Phi15_MaterialSteel.pdf',...
            'VEIntegrity_Phi30_MaterialDurableResin.pdf',...
            'VEIntegrity_Phi30_MaterialSteel.pdf',...
            'VEIntegrity_Phi45_MaterialSteel.pdf',...
            'VEShellability_Phi15_MaterialSteel.pdf',...
            'VEShellability_Phi30_MaterialDurableResin.pdf',...
            'VEShellability_Phi30_MaterialSteel.pdf',...
            'VEShellability_Phi45_MaterialSteel.pdf'};

xlabels = {'Mass [kg]','Mass [kg]','Mass [kg]','Mass [kg]','Mass [kg]','Mass [kg]','Mass [kg]','Mass [kg]',...
    'Energy [J]','Energy [J]','Energy [J]','Energy [J]','Energy [J]','Energy [J]','Energy [J]','Energy [J]'};
ylabels = {'Height [m]','Height [m]','Height [m]','Height [m]','Height [m]','Height [m]','Height [m]','Height [m]',...
    'Velocity [m/s]','Velocity [m/s]','Velocity [m/s]','Velocity [m/s]','Velocity [m/s]','Velocity [m/s]','Velocity [m/s]','Velocity [m/s]'};

%% Experimental Points

% get plotting data
if ismember(ind,1:4)||ismember(ind,9:12)
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

if ismember(ind,1:4)||ismember(ind,9:12)
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
xlabel(xlabels{ind},'FontSize',fontsize)
ylabel(ylabels{ind},'FontSize',fontsize)
zlabel = zlabel(zlabels{ind},'FontSize',fontsize,'rotation',0);

zlabel.Position(2) = zlabel.Position(2)+0.6;
zlabel.Position(1) = zlabel.Position(1)+0.2;

ax.OuterPosition = [0.2 0.2 0.8 0.8];

% set lims
xlim([min(Xgrid(:)) max(Xgrid(:))])
ylim([min(Ygrid(:)) max(Ygrid(:))])
zlim([0 110])

% rescale colormap based off of zlims
caxis(gca,[0 110]);

% title
% title(titles{ind},'FontSize',fontsize)

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