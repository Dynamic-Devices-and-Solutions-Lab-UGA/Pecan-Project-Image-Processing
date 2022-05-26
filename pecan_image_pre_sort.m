%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Script which displays each pecan image and moves them to the appropriate
% location based off of user input
%
% Author: Dani Agramonte
% Last Updated: 05.26.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% MATLAB initialization
clear; % Clear variables
clc;  % Clear command window.
workspace;  % Make sure the workspace panel is showing.

%% Main script

% pecan image processing folder - this is where all images are located pre
% sort
pre_sort_loc = ['C:\Users\Dani\Documents\'...
    'Pecan-Project-Image-Processing\'...
    'Pecan_Data_Master\'...
    'Pecan_Data-20220526_145147\'...
    'Pecan_Data-Image_Files'];

% pre sort location files
psl_files = dir(pre_sort_loc);

% delete directories
psl_files([psl_files.isdir]) = [];

for i = 1:numel(psl_files(