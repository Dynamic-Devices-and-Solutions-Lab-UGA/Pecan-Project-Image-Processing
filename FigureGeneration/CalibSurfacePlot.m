%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% plot sfit with custom settings for ease of viewing
%
% Author: Dani Agramonte
% Last Updated: 07.07.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% MATLAB initialization
clear; % Clear variables
clc;  % Clear command window.
workspace;  % Make sure the workspace panel is showing.

% remove warning which is given if a statement is unreachable
%#ok<*UNRCH>

% load data
load(fullfile(projectPath,'Pecan_Calibration_Data\Pecan_Calibration_Data_Main.mat'));

% load fit
load(fullfile(projectPath,'Pecan_Calibration_Data\PHE_calibration_sfit.mat'));

%% File variables

% print figure
printFlag = false;

%% Experimental Points

% obtain columns 4 and 5 which correspond to eccentricity and extent,
% respectively
[xData, yData, zData] = prepareSurfaceData(...
    pecan_calibration_data(:,4),...
    pecan_calibration_data(:,5), ...
    pecan_calibration_data(:,1));

% define excludedPoints
excludedPoints = excludedata(xData,yData,'Indices', [230 231] );

% redefine data vectors
xData = xData(~excludedPoints);
yData = yData(~excludedPoints);
zData = zData(~excludedPoints);

%% Define domain for calib surf

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
Zvals = feval(calib_surf,[Xgrid(:), Ygrid(:)]);

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
s = surf(Xgrid,Ygrid,Zvals);

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
view(ax,[115.440021713069 24.4095077862583]);

% define position vector
Position = [300, 150, 1100, 750];

% set size
set(fig, 'Position',  Position)

% axis labels
xlabel('$e_0$','FontSize',fontsize)
ylabel('$e_1$','FontSize',fontsize)
zlabel('$\displaystyle\frac{A_{poc}}{A_{prc}}$','FontSize',fontsize)

% set x and y lims
xlim([min(Xgrid(:)) max(Xgrid(:))])
ylim([min(Ygrid(:)) max(Ygrid(:))])

% title
title('$\widetilde{\Gamma}_{3}(e_0,e_1)$','FontSize',fontsize)

% set background to white
set(gcf,'color','white')

% turn off hold
hold(ax,'off');

if printFlag
    export_fig(gcf,fullfile(figurePath,'gammafunctionplot.pdf')) 
end