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

% image directory
im_dir = ['C:\Users\Dani\Documents\'...
    'Pecan-Project-Image-Processing\'...
    'Pecan_Data_Master\'...
    'Pecan_Data-20220526_145147\'...
    'Pecan_Data-Image_Files'];

% set locations for destination
prc_loc = fullfile(im_dir,'Pre_Crack');
poc_loc = fullfile(im_dir,'Post_Crack');
dd_loc = fullfile(im_dir,'Diseased');
uc_loc = fullfile(im_dir,'Uncracked');

% pre sort location files
psl_files = dir(pre_sort_loc);

% delete directories
psl_files([psl_files.isdir]) = [];

% stop flag for while loop
stop_flag = 0;

% initialize indexing variable
ix = 1;

while ~stop_flag
    
    % get current file
    current_file_path = fullfile(psl_files(ix).folder,psl_files(ix).name);
    
    % get image
    im = imread(current_file_path);
    
    % create figure handle
    h = figure(1);
    
    % constrain figure to always be on top
    WindowAPI(h,'TopMost')
    
    % show figure
    imshow(im)
    
    % gather user input on what to do with image
    % '1' - pre crack
    % '2' - post crack
    % '3' - uncracked
    % '4' - diseased
    % '5' - delete file
    
    % determine what action to take with currently opened image
    get_user_input()
    
    switch action
        case 1
            movefile(current_file_path,prc_loc);
        case 2
            movefile(current_file_path,poc_loc);
        case 3
            movefile(current_file_path,uc_loc);
        case 4
            movefile(current_file_path,dd_loc);
        case 5
            delete(current_file_path)
        otherwise
            % user did not input a valid action
            disp('input a valid action!')
            
            % retry
            continue
    end
    
    % check to see if stop flag value needs to be changed
    if ix == numel(psl_files)
        stop_flag = 1;
    else
        % else, increment indexing variable
        ix = ix+1;
    end
end

function action = get_user_input()
    % display help text
    fprintf(['\nGuide:\n'...
        '''1'' - pre crack\n'...
        '''2'' - post crack\n'...
        '''3'' - uncracked\n'...
        '''4'' - diseased\n'...
        '''5'' - delete file\n\n']);
    
    action = input('Action to take with file: ');
end