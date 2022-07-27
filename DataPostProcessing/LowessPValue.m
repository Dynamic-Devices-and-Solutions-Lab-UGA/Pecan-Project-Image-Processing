%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Calculate P value for Lowess fits of data
%
% Author: Dani Agramonte
% Last Updated: 07.09.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialize MATLAB

% clear variables; % Clear variables

clear; % Clear variables
clc;  % Clear command window.
workspace;  % Make sure the workspace panel is showing.

% remove warning which is given if a statement is unreachable
%#ok<*UNRCH>

%% load in data

% Data folder
dataFolder = fullfile(projectPath,'DataPostProcessing','LowessFits');

% get all files
files = dir(fullfile(dataFolder,'*.mat'));

%% Fit to test

ind = 1;

% load in data - start with the first one
load(fullfile(files(2).folder,files(ind).name));

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

% evalute function

if ismember(ind,1:4)||ismember(ind,9:12)
    Zvals = feval(PecanMeatIntegrity_sfit,[xData, yData]);
else
    Zvals = feval(PecanShellability_sfit,[xData, yData]);
end

% the null hypothesis is that our data is just an average
predictedNull = mean(zData);

% get residuals for the null hypothesis
residualsNull = zData-predictedNull;

% size of data
N_DataPoints = size(zData,1);

% number of iterations
N = 5000;

% initialize dsample matrix
dsample = zeros(N,1);

for i = 1:N
    yLocal = predictedNull+residualsNull(randperm(N_DataPoints));

    dSample = mean((yLocal-feval(PecanMeatIntegrity_sfit,[xData,yData]).^2));
end

