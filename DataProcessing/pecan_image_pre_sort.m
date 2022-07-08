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
im_dir = fullfile(projectPath,...
    'Pecan_Data_Master\Pecan_Data-20220526_145147\Pecan_Data-Image_Files');

% set locations for destination
prc_loc = fullfile(im_dir,'Pre_Crack');
poc_loc = fullfile(im_dir,'Post_Crack');
dd_loc = fullfile(im_dir,'Diseased');
uc_loc = fullfile(im_dir,'Uncracked');

% pre sort location files
psl_files = dir(im_dir);

% delete directories
psl_files([psl_files.isdir]) = [];

% stop flag for while loop
stop_flag = 0;

% initialize indexing variable
ix = 1;

while ~stop_flag
    
    % get current file
    current_file_path = fullfile(psl_files(ix).folder,psl_files(ix).name);
    
    % gather user input on what to do with image
    % '1' - pre crack
    % '2' - post crack
    % '3' - uncracked
    % '4' - diseased
    % '5' - delete file
    
    % run GUI script
    gui_pecan_image_sort(current_file_path,im_dir);
    
    % close all figures
    set(groot,'ShowHiddenHandles','on')
    c = get(groot,'Children');
    delete(c)
    disp(ix)
    
    % check to see if stop flag value needs to be changed
    if ix == numel(psl_files)
        stop_flag = 1;
    else
        % else, increment indexing variable
        ix = ix+1;
    end
end

%% Closeout MATLAB

clear; % Clear variables
clc;  % Clear command window.
workspace;  % Make sure the workspace panel is showing.