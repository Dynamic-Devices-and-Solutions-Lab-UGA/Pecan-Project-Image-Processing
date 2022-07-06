%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Calculate PHE calibration function surface fit and save 
%
% pecan_calib_surface_data_create -> PHE_calibration_function_create -> PHE (function) ...
% -> pecan_method_comparison -> pecan_method_comparison_plot
%
% Author: Dani Agramonte
% Last Updated: 04.27.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% MATLAB initialization
clear; % Clear variables
clc;  % Clear command window.
workspace;  % Make sure the workspace panel is showing.

load(fullfile(projectPath,'Pecan_Calibration_Data\Pecan_Calibration_Data_Main.mat'))

%% Fit data

% turn off nuisance warning
warning('off','curvefit:fit:iterationLimitReached')

% fit columns 4 and 5 which correspond to eccentricity and extent,
% respectively
[xData, yData, zData] = prepareSurfaceData(...
    pecan_calibration_data(:,4),...
    pecan_calibration_data(:,5), ...
    pecan_calibration_data(:,1));

% Set up fittype and options.
ft = fittype( 'poly11' );
excludedPoints = excludedata(xData,yData,'Indices', [230 231] );
opts = fitoptions( 'Method', 'LinearLeastSquares' );
opts.Robust = 'LAR';
opts.Exclude = excludedPoints;

% Fit model to data.
[calib_surf,qual_met,out_data] = fit([xData, yData],zData,ft,opts);

% turn on nuisance warning again
warning('on','curvefit:fit:iterationLimitReached')

set(groot,'defaultAxesTickLabelInterpreter','latex');  
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
% plot result
plot(calib_surf,...
    [pecan_calibration_data(~excludedPoints,4),...
    pecan_calibration_data(~excludedPoints,5)],...
    pecan_calibration_data(~excludedPoints,1))

fontsize = 26;
ax = gca;
ax.FontSize = fontsize; 
xlabel('Eccentricity','FontSize',fontsize)
ylabel('Extent','FontSize',fontsize)
zlabel('Calibration Ratio,$\frac{A_{poc}}{A_{prc}}$','FontSize',fontsize)
title('$\Gamma(e_0,e_1)$','FontSize',fontsize)

set(gcf,'color','white')
%% Shutdown tasks

% save 
save(fullfile(projectPath,'Pecan_Calibration_Data\PHE_calibration_sfit.mat'));
clear;