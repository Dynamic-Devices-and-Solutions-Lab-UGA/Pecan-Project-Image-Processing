%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Calculate PHE calibration function surface fit and save 
%
% Author: Dani Agramonte
% Last Updated: 04.27.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% MATLAB initialization
clear; % Clear variables
clc;  % Clear command window.
workspace;  % Make sure the workspace panel is showing.

load('C:\Users\Dani\Documents\Pecan-Project-Image-Processing\Pecan_Calibration_Data\Pecan_Calibration_Data_Main.mat')

%% Fit data

% turn off nuisance warning
warning('off','curvefit:fit:iterationLimitReached')

% fit columns 4 and 5 which correspond to eccentricity and extent,
% respectively
[calib_surf,qual_met,out_data] = fit(...
    [pecan_calibration_data(:,4),pecan_calibration_data(:,5)],...
    pecan_calibration_data(:,1),...
    'poly11',...
    'Robust','LAR');

% turn on nuisance warning again
warning('on','curvefit:fit:iterationLimitReached')

% plot result
scatter3(pecan_calibration_data(:,4),pecan_calibration_data(:,5),...
    pecan_calibration_data(:,1))
hold on
plot(calib_surf,...
    [pecan_calibration_data(:,4),pecan_calibration_data(:,5)],...
    pecan_calibration_data(:,1))

xlabel('Eccentricity')
ylabel('Extent')
zlabel('Calibration Ratio (post/pre)')

%% Shutdown tasks

% save 
save('C:\Users\Dani\Documents\Pecan-Project-Image-Processing\Pecan_Calibration_Data\PHE_calibration_sfit.mat');
clear;