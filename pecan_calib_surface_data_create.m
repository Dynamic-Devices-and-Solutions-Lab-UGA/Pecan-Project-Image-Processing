%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% load in calibration data and calculate necessary information so that
% calibration curves can be generated in 
%
% pecan_calib_surface_data_create -> PHE_calibration_function_create -> PHE (function) ...
% -> pecan_method_comparison -> pecan_method_comparison_plot
%
% Author: Dani Agramonte
% Last Updated: 05.06.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% MATLAB initialization
clear; % Clear variables
clc;  % Clear command window.
workspace;  % Make sure the workspace panel is showing.
clear('textprogressbar'); % clear persistent vars in textprogressbar

% set debug parameter
debug = 'false'; % valid values are 'true' or 'false'

%% Load in data and calculate dates in unix time

% Get pre crack files
pre_crack_files = dir(fullfile(projectPath,'Pecan_Calibration_Images','Pre_Crack','*.jpg'));

% number of pre crack pecans
n_pecan_pre_crack = size(pre_crack_files,1);

% initialize double array of pre crack time stamps
time_stamps_pre_crack = zeros(n_pecan_pre_crack,1);

% get photo timestamps for pre crack files in unix time
for i = 1:n_pecan_pre_crack
    time_stamps_pre_crack(i) = time_unix(pre_crack_files(i).name);
end

% Get post crack files
post_crack_files = dir(fullfile(projectPath,'Pecan_Calibration_Images','Post_Crack','*.jpg'));

% number of post crack files; equals number of calibration points
n_pecan_post_crack = size(post_crack_files,1);

% initialize double array of post crack time stamps
time_stamps_post_crack = zeros(n_pecan_post_crack,1);

% get photo timestamps for post crack files
for i = 1:n_pecan_post_crack
    time_stamps_post_crack(i) = time_unix(post_crack_files(i).name);
end

% Get diseased files
diseased_files = dir(fullfile(projectPath,'Pecan_Calibration_Images','Diseased','*.jpg'));

% number of diseased files
n_pecan_diseased = size(diseased_files,1);

% initialize double array of diseased time stamps
time_stamps_diseased = zeros(n_pecan_diseased,1);

% get photo timestamps for diseased files
for i = 1:n_pecan_diseased
    time_stamps_diseased(i) = time_unix(diseased_files(i).name);
end

%% Order array

% array of timestamps for all files
time_stamps_aggregate = [time_stamps_pre_crack;...
    time_stamps_post_crack;time_stamps_diseased];

% sorted time stamp array
[time_stamps_aggregate_sort, I_sort] = sort(time_stamps_aggregate);

% initialize array of calibration data
%
% | ratio between area post/pre | area pre | length/width pre | eccentricity | extent
%
pecan_calibration_data = zeros(n_pecan_post_crack,5);

% get array of post crack indices
I_sort_post_crack = zeros(n_pecan_post_crack,1);

for i = 1:n_pecan_post_crack
    I_sort_post_crack(i) = find(I_sort == (n_pecan_pre_crack+i));
end

%% Populate calibration data matrix

textprogressbar(pad('populating calibration matrix:',60));
for i = 1:n_pecan_post_crack
    textprogressbar(100*(i/n_pecan_post_crack));
    % get post crack index and filename
    post_crack_ind = I_sort(I_sort_post_crack(i))-n_pecan_pre_crack;
    post_crack_file = fullfile(...
        post_crack_files(post_crack_ind).folder,...
        post_crack_files(post_crack_ind).name);
    
    % initialize indexing variable
    j = 1;
    
    % count backwards until a pre crack index is found
    while true
        if I_sort(I_sort_post_crack(i)-j)<=n_pecan_pre_crack
            pre_crack_ind = I_sort(I_sort_post_crack(i)-j);
            break
        else
            j = j+1;
        end
    end
    
    % get pre crack filename
    pre_crack_file = fullfile(...
        pre_crack_files(pre_crack_ind).folder,...
        pre_crack_files(pre_crack_ind).name);
    
    switch debug
        case 'true'
            % pre crack data
            [pre_crack_area,pre_crack_pec_length,pre_crack_pec_width,~,...
                pre_crack_bw,pre_crack_ecc,pre_crack_ext] = ...
                pecan_property_get(pre_crack_file,'debug','true');

            % post crack data
            [post_crack_area,post_crack_pec_length,post_crack_pec_width,~,...
                post_crack_bw,post_crack_ecc,post_crack_ext] = ...
                pecan_property_get(post_crack_file,'debug','true');

            % updates all figures
            drawnow

            % pause matlab for 2s
            duration = 2;
            java.lang.Thread.sleep(duration*1000) 

            close all;
        case 'false'
            % pre crack data
            [pre_crack_area,pre_crack_pec_length,pre_crack_pec_width,~,...
                pre_crack_bw,pre_crack_ecc,pre_crack_ext] = ...
                pecan_property_get(pre_crack_file);

            % post crack data
            [post_crack_area,post_crack_pec_length,post_crack_pec_width,~,...
                post_crack_bw,post_crack_ecc,post_crack_ext] = ...
                pecan_property_get(post_crack_file);
    end
    
    % save variables to pecan_calibration_data matrix
    pecan_calibration_data(i,1) = post_crack_area/pre_crack_area;
    pecan_calibration_data(i,2) = pre_crack_area;
    pecan_calibration_data(i,3) = pre_crack_pec_length/pre_crack_pec_width;
    pecan_calibration_data(i,4) = pre_crack_ecc;
    pecan_calibration_data(i,5) = pre_crack_ext;
end
textprogressbar('terminated');

%% Shutdown tasks

% save data to .mat file
save(fullfile(projectPath,'Pecan_Calibration_Data',...
    'Pecan_Calibration_Data_Main.mat'),'pecan_calibration_data');

switch debug
    case 'false'
        % clear data
        clear; % Clear variables
        clc;  % Clear command window.
end