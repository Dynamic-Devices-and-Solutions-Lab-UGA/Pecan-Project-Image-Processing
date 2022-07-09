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
load(fullfile(projectPath,'Calibration\Pecan_Calibration_Data\PMC_Data.mat'),'pecan_method_comp')

% remove warning which is given if a statement is unreachable
%#ok<*UNRCH>

% set print flag
printFlag = false;

% set debug flag
debugFlag = false;

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

%% calculate statistical measures

% calculate mean
bbmean = mean(pecan_method_comp(:,1));
damean = mean(pecan_method_comp(:,2));
csmean = mean(pecan_method_comp(:,3));

% error in mean
errorbb = abs((bbmean-100)/bbmean)*100;
errorda = abs((damean-100)/damean)*100;
errorcs = abs((csmean-100)/csmean)*100;

% calculate standard deviations
stdbb = std(pecan_method_comp(:,1));
stdda = std(pecan_method_comp(:,2));
stdcs = std(pecan_method_comp(:,3));

%% plot settings

fontsize = 26;
tikfontsize = 20;
Position = [300, 150, 750, 750];

% set default interpreter
set(groot,'defaultAxesTickLabelInterpreter','latex');  
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

%% plot distributions with bar graph
fig1 = figure(1);
set(gcf, 'Position',  Position)
% order color according to Cynthia Brewer's research
colororder(linspecer(3));

bar(binRange,[hcbb;hcda;hccs]')
ax = gca;
ax.FontSize = tikfontsize; 
title('Histogram comparison for different methods','FontSize',fontsize)
xlabel('Percentage estimate','FontSize',fontsize)
ylabel('Number of datapoints','FontSize',fontsize)
legend('bounding box','direct area','calib surf','FontSize',fontsize,'Location','NorthWest')

set(gcf,'color','white')

if printFlag
    export_fig(gcf,fullfile(figurePath,'Histogram_Comp.pdf')) 
end

%% plot cdfs
fig2 = figure(2);
set(gcf, 'Position',  Position)

% order color according to Cynthia Brewer's research
colororder(linspecer(3));


[fbb,xbb,flobb,fupbb] = ecdf(pecan_method_comp(:,1),'Bounds','on','Alpha',0.01);
[fda,xda,floda,fupda] = ecdf(pecan_method_comp(:,2),'Bounds','on','Alpha',0.01);
[fcs,xcs,flocs,fupcs] = ecdf(pecan_method_comp(:,3),'Bounds','on','Alpha',0.01);

LineWidth = 1.5;

% CDF
plot(xbb,fbb,'LineWidth',LineWidth)
hold on
plot(xda,fda,'LineWidth',LineWidth)
plot(xcs,fcs,'LineWidth',LineWidth)

% upper bounds
plot(xbb,flobb,'LineStyle',':','LineWidth',LineWidth)
plot(xda,floda,'LineStyle',':','LineWidth',LineWidth)
plot(xcs,flocs,'LineStyle',':','LineWidth',LineWidth)

% lower bounds
plot(xbb,fupbb,'LineStyle',':','LineWidth',LineWidth)
plot(xda,fupda,'LineStyle',':','LineWidth',LineWidth)
plot(xcs,fupcs,'LineStyle',':','LineWidth',LineWidth)

ax = gca;
ax.FontSize = tikfontsize; 

% plot cdfs
title('CDFs for different methods','FontSize',fontsize)
xlabel('Percentage estimate','FontSize',fontsize)
ylabel('CDF at val','FontSize',fontsize)
legend('bounding box','direct area','calib surf','FontSize',fontsize,'Location','NorthWest')
set(gcf,'color','white')
xlim([80 120])
grid off

if printFlag
    export_fig(gcf,fullfile(figurePath,'CDF_Comp.pdf')) 
end


%% Shutdown tasks

switch debugFlag
    case 'false'
        % clear data
        clear; % Clear variables
        clc;  % Clear command window.
end