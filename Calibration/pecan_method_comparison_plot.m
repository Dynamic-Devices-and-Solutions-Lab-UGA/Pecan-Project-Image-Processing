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
load(fullfile(projectPath,'Pecan_Calibration_Data\PMC_Data.mat'),'pecan_method_comp')

%% Plot

% set binRange
binRange = 78:2:114;

% histcounts
hcbb = histcounts(pecan_method_comp(:,1),[binRange Inf]);
hcda = histcounts(pecan_method_comp(:,2),[binRange Inf]);
hccs = histcounts(pecan_method_comp(:,3),[binRange Inf]);

% fit burr distributions
loglogistic_bb = fitdist(pecan_method_comp(:,1),'loglogistic');
loglogistic_da = fitdist(pecan_method_comp(:,2),'loglogistic');
loglogistic_cs = fitdist(pecan_method_comp(:,3),'loglogistic');

fontsize = 26;
Position = [300, 150, 750, 750];

% plot distributions with bar graph
fig1 = figure(1);
set(gcf, 'Position',  Position)
% order color according to Cynthia Brewer's research
colororder(linspecer(3));
ax = gca;
ax.FontSize = fontsize; 

bar(binRange,[hcbb;hcda;hccs]')
title('Histogram comparison for different methods','FontSize',fontsize)
xlabel('Percentage estimate','FontSize',fontsize)
ylabel('Number of datapoints','FontSize',fontsize)
legend('bounding box','direct area','calib surf','FontSize',fontsize,'Location','NorthWest')

set(gcf,'color','white')

% plot cdfs
fig2 = figure(2);
set(gcf, 'Position',  Position)
% order color according to Cynthia Brewer's research
colororder(linspecer(3));

% experimental CDFs
cdfplot(pecan_method_comp(:,1))
hold on
cdfplot(pecan_method_comp(:,2))
cdfplot(pecan_method_comp(:,3))

% plot cdfs
title('CDFs for different methods','FontSize',fontsize)
xlabel('Percentage estimate','FontSize',fontsize)
ylabel('CDF at val','FontSize',fontsize)
legend('bounding box','direct area','calib surf','FontSize',fontsize,'Location','NorthWest')
set(gcf,'color','white')
xlim([80 110])
grid off