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
workspace;  % Make sure the workspace panel is showing.
commandwindow();

% Data folder
folder = fullfile(projectPath,'Pecan_Surface_Fits');

% file name
name = 'pecanMultiObjectiveWeightStudy-Angle.30-Material.Steel.mat';

% set path of where data is located
data_path = fullfile(folder,name);

load(data_path,'sol','solval');

%% Main script

% get pecan integrity metric
pecanIntegrity = solval(:,:,1);

% get shellability metric
pecanShellability = solval(:,:,2);

% get optimal mass for each weight
massOpt = sol(:,:,1);

% get optimal height for each weight
heightOpt = sol(:,:,2);

set(groot,'defaultAxesTickLabelInterpreter','latex');  
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

fontsize = 22;



figure(1)
[X1,X2] = meshgrid(w1,w2);
surf(X1,X2,pecanShellability,pecanIntegrity)
xlabel('Pecan Integrity Weight, $w_{\Psi}$ ','FontSize',fontsize)
ylabel('Pecan Shellability Weight, $w_{\Xi}$ ','FontSize',fontsize)
zlabel('Pecan Shellability, $\Xi [\%]$')
colormap(jet)
c = colorbar;
c.Label.String = 'Pecan Integrity, $\Psi [\%]$';
c.Label.Interpreter = 'latex';
%c.Label.Position(1) = 3;
ax = gca;
ax.FontSize = fontsize; 
set(gcf,'color','white')
title('Pareto optimal surface in domain when Angle=30 and Material=Steel','FontSize',fontsize)
view(ax,[71.4732087227414 25.3512393887946]);
grid(ax,'on');
hold(ax,'off');
set(gcf,'Position',[241 201 1452 755])

%{
figure(2)
[X1,X2] = meshgrid(w1,w2);
surf(X1,X2,pecanIntegrity,pecanShellability)
xlabel('Pecan Integrity Weight, $w_{\Psi}$ ','FontSize',fontsize)
ylabel('Pecan Shellability Weight, $w_{\Xi}$ ','FontSize',fontsize)
zlabel('Pecan Integrity, $\Psi$ [\%] ','FontSize',fontsize)
title('Pareto optimal surface in domain when Angle=30 and Material=Steel','FontSize',fontsize)
colormap(jet)
c = colorbar;
c.Label.String = 'Pecan Shellability, $\Xi$';
c.Label.Interpreter = 'latex';
ax = gca;
ax.FontSize = fontsize; 
set(gcf,'color','white')
view(ax,[71.4732087227414 25.3512393887946]);
grid(ax,'on');
hold(ax,'off');
set(gcf,'Position',[241 201 1452 755])
view(ax,[-115.9163 36.7847])

figure(3)
surf(X1,X2,massOpt,heightOpt)
xlabel('Pecan Integrity Weight, $w_{\Psi}$ ','FontSize',fontsize)
ylabel('Pecan Shellability Weight, $w_{\Xi}$ ','FontSize',fontsize)
zlabel('Optimal Mass [g]','FontSize',fontsize)
colormap(jet)
c = colorbar;
c.Label.String = 'Optimal Height [cm]';
c.Label.Interpreter = 'latex';
ax = gca;
ax.FontSize = fontsize; 
set(gcf,'color','white')
view(ax,[71.4732087227414 25.3512393887946]);
grid(ax,'on');
hold(ax,'off');
title('Pareto optimal surface in codomain when Angle=30 and Material=Steel','FontSize',fontsize)
set(gcf,'Position',[241 201 1452 755])


figure(4)
surf(X1,X2,heightOpt,massOpt)
xlabel('Pecan Integrity Weight, $w_{\Psi}$ ','FontSize',fontsize)
ylabel('Pecan Shellability Weight, $w_{\Xi}$ ','FontSize',fontsize)
zlabel('Optimal Height [h]','FontSize',fontsize)
colormap(jet)
c = colorbar;
c.Label.String = 'Optimal Mass [g]';
c.Label.Interpreter = 'latex';
ax = gca;
ax.FontSize = fontsize; 
set(gcf,'color','white')
view(ax,[71.4732087227414 25.3512393887946]);
grid(ax,'on');
hold(ax,'off');
title('Pareto optimal surface in codomain when Angle=30 and Material=Steel','FontSize',fontsize)
set(gcf,'Position',[241 201 1452 755])
%}