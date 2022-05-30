%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Compare direct area method, bounding box, and calibrated surface methods
%
% pecan_calib_surface_data_create -> PHE_calibration_function_create -> PHE (function) ...
% -> pecan_method_comparison -> pecan_method_comparison_plot
%
% Author: Dani Agramonte
% Last Updated: 04.28.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% MATLAB initialization
close all; % close all windows
clear; % Clear variables
clc;  % Clear command window.
workspace;  % Make sure the workspace panel is showing.

% load in method comparison data
load('C:\Users\Dani\Documents\Pecan-Project-Image-Processing\'...
    'Pecan_Calibration_Data\PMC_Data.mat'],'pecan_method_comp')

%% Plot

% set binRange
binRange = 78:2:114;

% histcounts
hcbb = histcounts(pecan_method_comp(:,1),[binRange Inf]);
hcda = histcounts(pecan_method_comp(:,2),[binRange Inf]);
hccs = histcounts(pecan_method_comp(:,3),[binRange Inf]);

% fit burr distributions
burr_bb = fitdist(pecan_method_comp(:,1),'Weibull');
burr_da = fitdist(pecan_method_comp(:,2),'Weibull');
burr_cs = fitdist(pecan_method_comp(:,3),'Weibull');

% plot distributions with bar graph
figure(1)
bar(binRange,[hcbb;hcda;hccs]')
title('Histogram comparison for different methods')
xlabel('Percentage estimate')
ylabel('Number of datapoints')
legend('bounding box','direct area','calib surf')

% plot cdfs
figure(2)
% experimental CDFs
cdfplot(pecan_method_comp(:,1))
hold on
cdfplot(pecan_method_comp(:,2))
cdfplot(pecan_method_comp(:,3))

% find mins and maxes for different data
min_bb = min(pecan_method_comp(:,1));
max_bb = max(pecan_method_comp(:,1));
min_da = min(pecan_method_comp(:,2));
max_da = max(pecan_method_comp(:,2));
min_cs = min(pecan_method_comp(:,3));
max_cs = max(pecan_method_comp(:,3));

% find x values
x_bb = linspace(min_bb,max_bb,1e5);
x_da = linspace(min_da,max_da,1e5);
x_cs = linspace(min_cs,max_cs,1e5);

% plot cdfs
plot(x_bb,cdf(burr_bb,x_bb))
plot(x_da,cdf(burr_da,x_da))
plot(x_cs,cdf(burr_cs,x_cs))
title('CDFs for different methods')
xlabel('Percentage estimate')
ylabel('CDF at val')
legend('bounding box','direct area','calib surf')