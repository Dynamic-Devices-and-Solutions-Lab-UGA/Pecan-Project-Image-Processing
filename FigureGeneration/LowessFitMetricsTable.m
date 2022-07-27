%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Assemble fit metrics into table
%
% Author: Dani Agramonte
% Last Updated: 07.13.22
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

%% Collect data

% initialize metrics matrix
fitMetrics = zeros(2,16);

for i = 1:16
    % load in data - start with the first one
    load(fullfile(files(2).folder,files(i).name));

    if ismember(i,[1:4,9:12])
        % get metrics for each fit
        localMetrics = [gIntegrity.adjrsquare;gIntegrity.rmse];
    else
        % get metrics for each fit
        localMetrics = [gShellability.adjrsquare;gShellability.rmse];
    end

    % assign column to matrix
    fitMetrics(:,i) = localMetrics;
end