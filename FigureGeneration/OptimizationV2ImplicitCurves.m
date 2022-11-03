%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Plot lowess fits
%
% Author: Dani Agramonte
% Last Updated: 07.07.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Load in Data

% Data folder
dataFolder = fullfile(projectPath,'DataPostProcessing','LowessFits');

% Saving folder
saveFolder = fullfile(projectPath,'FigureGeneration','LevelSetOptim');

% get all files
files = dir(fullfile(dataFolder,'*.mat'));

%% Script Main Parameters

% print flag
printFlag = 0;

%% MH Figure

Fontsize = 26;
% set default interpreter
set(groot,'defaultAxesTickLabelInterpreter','latex');  
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

% initialize figure 1
fig1 = figure(1);
colororder(linspecer(4))


for i = 1:4
    % load in integrity sfits
    load(fullfile(files(2).folder,files(i).name));

    % load in shellability sfits
    load(fullfile(files(2).folder,files(i+4).name));

    % calculate bounds over which fit is valid - start off with the min/max
    % x and y values
    xFitVals = var_outIntegrity(:,1);
    yFitVals = var_outIntegrity(:,2);

    xFitMin = min(xFitVals);
    xFitMax = max(xFitVals);
    yFitMin = min(yFitVals);
    yFitMax = max(yFitVals);
    
    fig2 = figure(2);
    fp = fimplicit(@(x,y) PecanMeatIntegrity_sfit(x,y)-90,[xFitMin xFitMax yFitMin yFitMax],'Visible','off','MeshDensity',1e2);

    figure(1);
    % use Cynthia Brewer's research to make a colormap for the surface fit
    plot3(fp.XData',fp.YData',PecanShellability_sfit(fp.XData',fp.YData'),'LineWidth',3)
    hold on
    maxShellMH(i) = max(PecanShellability_sfit(fp.XData',fp.YData')); %#ok<SAGROW> 
end
close(fig2);

% set axis limits
xlim([0.30 1.00])
ylim([0.1 1.100])
zlim([55 100])
% set figure background to white
set(gcf,'Color','White')
% create legend
legend('$\phi = 15^{\circ}$, material = steel','$\phi = 30^{\circ}$, material = durable resin',...
    '$\phi= 30^{\circ}$, material = steel','$\phi = 45^{\circ}$, material = steel','FontSize',Fontsize)
% set fontsize
set(gca,'FontSize',Fontsize)
% set view angle
set(gca,'CameraPosition',[6.4832    2.5014  140.2481])
% set Figure Position
set(gcf,'Position',[262         154        1492         715])
% turn on grid
grid on
% axis labels
xlabel('Height [m]','FontSize',Fontsize)
ylabel('Mass [kg]','FontSize',Fontsize)
zlabel('$\Xi(M,H) [\%]$','FontSize',Fontsize)

% save data
if printFlag
    export_fig(gcf,fullfile(saveFolder,'MHLevelSetOptim.pdf'))
    close all;
end

%% VE Figure

Fontsize = 26;
% set default interpreter
set(groot,'defaultAxesTickLabelInterpreter','latex');  
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

% initialize figure 1
fig2 = figure(2);
colororder(linspecer(4))


for i = 9:12
    % load in integrity sfits
    load(fullfile(files(2).folder,files(i).name));

    % load in shellability sfits
    load(fullfile(files(2).folder,files(i+4).name));

    % calculate bounds over which fit is valid - start off with the min/max
    % x and y values
    xFitVals = var_outIntegrity(:,1);
    yFitVals = var_outIntegrity(:,2);

    xFitMin = min(xFitVals);
    xFitMax = max(xFitVals);
    yFitMin = min(yFitVals);
    yFitMax = max(yFitVals);
    
    fig3 = figure(3);
    fp = fimplicit(@(x,y) PecanMeatIntegrity_sfit(x,y)-90,[xFitMin xFitMax yFitMin yFitMax],'Visible','off','MeshDensity',1e2);

    figure(2);
    % use Cynthia Brewer's research to make a colormap for the surface fit
    plot3(fp.XData',fp.YData',PecanShellability_sfit(fp.XData',fp.YData'),'LineWidth',3)
    maxShellVE(i) = max(PecanShellability_sfit(fp.XData',fp.YData')); %#ok<SAGROW> 
    hold on
end
close(fig3);

% set axis limits
% xlim([30 100])
% ylim([100 1100])
zlim([55 100])
% set figure background to white
set(gcf,'Color','White')
% create legend
legend('$\phi = 15^{\circ}$, material = steel','$\phi = 30^{\circ}$, material = durable resin',...
    '$\phi= 30^{\circ}$, material = steel','$\phi = 45^{\circ}$, material = steel','FontSize',Fontsize)
% set fontsize
set(gca,'FontSize',Fontsize)
% set view angle
set(gca,'CameraPosition',[-51.9978  -15.7163  170.0579])
% set Figure Position
set(gcf,'Position',[262         154        1492         715])
% turn on grid
grid on
% axis labels
xlabel('Energy [J]','FontSize',Fontsize)
ylabel('Velocity [m/s]','FontSize',Fontsize)
zlabel('$\Xi(V,E) [\%]$','FontSize',Fontsize)

% save data
if printFlag
    export_fig(gcf,fullfile(saveFolder,'VELevelSetOptim.pdf'))
    close all;
end