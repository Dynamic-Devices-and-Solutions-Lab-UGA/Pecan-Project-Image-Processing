%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Image classification script to classify pecans as either pre or post
% crack
%
% Author: Dani Agramonte
% Last Updated: 03.25.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Dataset path
PecanDatasetPath = fullfile(pwd,'Pecan_Data_03.24.22');

% Categorize images based on the folder they're in
imds = imageDatastore(PecanDatasetPath, ...
    'IncludeSubfolders',true,'LabelSource','foldernames');

