%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Compare direct area method vs bounding box scaling method
%
% Author: Dani Agramonte
% Last Updated: 03.30.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; % Clear variables
clc;  % Clear command window.
workspace;  % Make sure the workspace panel is showing.

% The following is for full half comparison

%{
% Get pre crack files
pre_crack_files = dir(fullfile(fullfile(pwd,...
    'Pecan_Data_03.24.22/Pre_Crack'), '*.jpg'));
pre_crack_files = [pre_crack_files; dir(fullfile(fullfile(pwd,...
    'Pecan_Data_03.31.22_Test_Full_Halves/Pre_Crack'), '*.jpg'))];
%}

% The following is for partial half comparison
pre_crack_files = dir(fullfile(fullfile(pwd,...
    'Pecan_Data_03.31.22_Test_Partial_Halves/Pre_Crack'), '*.jpg'));


% number of pecans to consider
n_pecan_pre_crack = length(pre_crack_files);

% initialize double array of pre crack time stamps
time_stamps_pre_crack = zeros(n_pecan_pre_crack,1);

% get photo timestamps for pre crack files
for i = 1:n_pecan_pre_crack
    time_stamps_pre_crack(i) = str2double(extractBetween(...
        pre_crack_files(i).name,'_','.'));
end


% The following is for full half comparison

%{
% Get post crack files
post_crack_files = dir(fullfile(fullfile(pwd,...
    'Pecan_Data_03.24.22/Post_Crack'), '*.jpg'));
post_crack_files = [post_crack_files; dir(fullfile(fullfile(pwd,...
    'Pecan_Data_03.31.22_Test_Full_Halves/Post_Crack'), '*.jpg'))];
%}


% The following is for partial half comparison
post_crack_files = dir(fullfile(fullfile(pwd,...
    'Pecan_Data_03.31.22_Test_Partial_Halves/Post_Crack'), '*.jpg'));


% number of full halves to consider
n_pecan_post_crack = length(post_crack_files);

% initialize double array of pre crack time stamps
time_stamps_post_crack = zeros(n_pecan_post_crack,1);

% get photo timestamps for pre crack files
for i = 1:n_pecan_post_crack
    time_stamps_post_crack(i) = str2double(extractBetween(...
        post_crack_files(i).name,'_','.'));
end

% array of timestamps for all files
time_stamps_aggregate = [time_stamps_pre_crack;time_stamps_post_crack];

% sorted time stamp array
[time_stamps_aggregate_sort, I_sort] = sort(time_stamps_aggregate);

% initialize array of comparison
pecan_method_comp = zeros(n_pecan_post_crack,2);

% get array of post crack indices
I_sort_post_crack = zeros(n_pecan_post_crack,1);

for i = 1:n_pecan_post_crack
    I_sort_post_crack(i) = find(I_sort == (n_pecan_pre_crack+i));
end

% use bounding box method
for i = 1:n_pecan_post_crack
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
    
    % get filename
    pre_crack_file = fullfile(...
        pre_crack_files(pre_crack_ind).folder,...
        pre_crack_files(pre_crack_ind).name);
    
    [pecan_method_comp(i,1),~,~] = PHE(pre_crack_file,post_crack_file,...
        'method','bounding_box','pre_cracked_bw','true');
end

% use direct area method
for i = 1:n_pecan_post_crack
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
    
    % get filename
    pre_crack_file = fullfile(...
        pre_crack_files(pre_crack_ind).folder,...
        pre_crack_files(pre_crack_ind).name);
    
    [pecan_method_comp(i,2),~,~] = PHE(pre_crack_file,post_crack_file,...
        'method','direct_area');
end