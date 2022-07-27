%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Plot lowess fits
%
% Author: Dani Agramonte
% Last Updated: 07.07.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% load in data

% Data folder
dataFolder = fullfile(projectPath,'DataPostProcessing','ParetoOptimization');

% get all files
files = dir(fullfile(dataFolder,'*.mat'));

%% main

fig1 = figure(2);

for i = 1:4
    % load in data - start with the first one
    load(fullfile(files(2).folder,files(i).name));

    Psi = solval(:,:,1);
    Xi = solval(:,:,2);
    
    PsiShift = Psi-90;
    figure(1)
    fp = fimplicit(@(x,y) interpolatesurf(x,y,W1,W2,PsiShift),[0 10 0 10],'Visible','off');

    figure(2)
    % use Cynthia Brewer's research to make a colormap for the surface fit
    colormap(linspecer);
    plot3(fp.XData',fp.YData',interpolatesurfXi(fp.XData',fp.YData',W1,W2,Xi))
    hold on
end

Fontsize = 26;
% set default interpreter
set(groot,'defaultAxesTickLabelInterpreter','latex');  
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');


xlabel('$W_{(\Psi)}$','FontSize',Fontsize)
ylabel('$W_{(\Xi)}$','FontSize',Fontsize)
zlabel('$\Xi(M^{\star},H^{\star}) [\%]$','FontSize',Fontsize)

% set background to white
set(gcf,'color','white')

% Create axes object
ax1 = gca;

grid on

% set axis fontsize
set(ax1,'FontSize',Fontsize);

% set axis viewpoint
view(ax1,[-17.2965517241379 23.424919945407]);

set(fig1,'Position',[100 100 1600 900])

legend('$\phi = 15^{\circ}$, material = steel','$\phi = 30^{\circ}$, material = durable resin',...
    '$\phi= 30^{\circ}$, material = steel','$\phi = 45^{\circ}$, material = steel','FontSize',Fontsize)

fig2 = figure(4);

for i = 5:8
    % load in data - start with the first one
    load(fullfile(files(2).folder,files(i).name));

    Psi = solval(:,:,1);
    Xi = solval(:,:,2);
    
    PsiShift = Psi-90;
    figure(3)
    fp = fimplicit(@(x,y) interpolatesurf(x,y,W1,W2,PsiShift),[0 10 0 10],'Visible','off');

    figure(4)
    % use Cynthia Brewer's research to make a colormap for the surface fit
    colormap(linspecer);
    plot3(fp.XData',fp.YData',interpolatesurfXi(fp.XData',fp.YData',W1,W2,Xi))
    hold on
end

Fontsize = 26;
% set default interpreter
set(groot,'defaultAxesTickLabelInterpreter','latex');  
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');


xlabel('$W_{(\Psi)}$','FontSize',Fontsize)
ylabel('$W_{(\Xi)}$','FontSize',Fontsize)
zlabel('$\Xi(V^{\star},E^{\star}) [\%]$','FontSize',Fontsize)

% set background to white
set(gcf,'color','white')

% Create axes object
ax1 = gca;

% set axis fontsize
set(ax1,'FontSize',Fontsize);

% set axis viewpoint
view(ax1,[8.47568477971814 15.8546202178866]);

set(fig2,'Position',[100 100 1600 900])

grid on

legend('$\phi = 15^{\circ}$, material = steel','$\phi = 30^{\circ}$, material = durable resin',...
    '$\phi= 30^{\circ}$, material = steel','$\phi = 45^{\circ}$, material = steel','FontSize',Fontsize)

% store file with export_fig
store_loc = fullfile(projectPath,'FigureGeneration\Thesis_Plots');
filename = sprintf('MHimplicitCurveFigure.pdf');
export_fig(fig1,fullfile(store_loc,filename));

% store file with export_fig
store_loc = fullfile(projectPath,'FigureGeneration\Thesis_Plots');
filename = sprintf('VEimplicitCurveFigure.pdf');
export_fig(fig2,fullfile(store_loc,filename));

function out = interpolatesurf(xq,yq,W1,W2,PsiShift)

out = interp2(W1,W2,PsiShift,xq,yq);
end

function out = interpolatesurfXi(xq,yq,W1,W2,Xi)

out = interp2(W1,W2,Xi,xq,yq);
end

