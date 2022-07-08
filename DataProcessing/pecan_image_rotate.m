%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Simple script which rotates sets of images by specified angles
%
% Author: Dani Agramonte
% Last Updated: 05.28.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% MATLAB initialization
clear; % Clear variables
clc;  % Clear command window.
workspace;  % Make sure the workspace panel is showing.

%% create workers if they don't exist

pool_control('start')

%% main

% main data path
dataPath = fullfile(projectPath,...
    'Pecan_Data_Master\Pecan_Data-20220526_145147\Pecan_Data-Image_Files');

% possible states
pecState = {'Pre_Crack','Post_Crack'};

% choose state
state = 1;

% get all filepaths
imPaths = dir(fullfile(dataPath,pecState{state}));

% remove any directories
imPaths([imPaths.isdir]) = [];

% indexing information - set this by inspecting image files manually - please using below format
% | (start image) 1 | (start image) 2 | (start image) 3 | ...
% | (end image)   1 | (end image)   2 | (end image)   3 | ...

indexInfo = ...
    {
    '20220526_021420.jpg','20220526_063509.jpg';...
    %%
    '20220526_033348.jpg','20220526_065619.jpg';...
    };

%%%%%%%% NOTE %%%%%%%%
% There is a bug for some reason that messes with the angle when first importing the .jpg's from
% the Android. It's not know why this is occurring, but SUBTRACT 90 to the angle in angleInfo
%
% angle information - set this by inspecting the image files manually - please use the below format
% | (angle)       1 | (angle)       2 | (angle)       3 | ...
angleInfo = [180, 180];

for i = 1:size(indexInfo,2)
    % get image names
    imNames = {imPaths(:).name};
    
    % start and stop indices
    start_i = find(strcmp(imNames,indexInfo{1,i}));
    stop_i = find(strcmp(imNames,indexInfo{2,i}));
    
    % define angle info local
    angleInfoLocal = angleInfo(i)/90;
    
    parfor j = start_i:stop_i
        % local path
        imLocalPath = fullfile(imPaths(j).folder,imPaths(j).name);
        
        % load image
        imLocal = imread(imLocalPath);
        
        % rotate image
        imLocal = rot90(imLocal,angleInfoLocal);
        
        % save image - note that imwrite is in overwrite mode
        imwrite(imLocal,imLocalPath)
    end
end