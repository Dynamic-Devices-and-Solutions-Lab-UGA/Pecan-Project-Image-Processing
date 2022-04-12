%function pecan_data_struct = pecan_data_struct_create(varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Create data structure with all the important properties about a given
% pecan test run including metadata, test parameters, and results.
%
% Inputs
% ---------------
% varargin             : optional inputs (see explanation)
% 
% Optional Inputs
% ---------------
% NOT SURE YET
%
% Outputs
% ---------------
% pecan_data_struct    : data structure with all data about all pecan tests 
%
% Author: Dani Agramonte
% Last Updated: 04.11.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% load in data and initialize/preallocate arrays for force processing

% get force files
force_files = dir(fullfile(fullfile(pwd,...
    'PecanDataMaster','PecanData-converted'), '*.tdms'));

% number of force files
n_force_files = length(force_files);

% initialize and preallocate
pecan_test_metadata = cell(n_force_files,1);

% get metadata for all force files
for i = 1:n_force_files
    pecan_test_metadata(i) = {force_files(i).name(1:48)};
end

% get unique values 
pecan_test_meta_data_unique = unique(pecan_test_metadata);



%% load in data and initialize/preallocate arrays for image processing

%% get precrack files
pre_crack_files = dir(fullfile(fullfile(pwd,...
    'PecanDataMaster','PecanData-images/Pre_Crack'), '*.jpg'));

% number of pecans to consider
n_pecan_pre_crack = length(pre_crack_files);

% initialize double array of pre crack time stamps
time_stamps_pre_crack = zeros(n_pecan_pre_crack,1);

% get photo timestamps for pre crack files
for i = 1:n_pecan_pre_crack
    time_stamps_pre_crack(i) = str2double(extractBetween(...
        pre_crack_files(i).name,'_','.'));
end

%% get postcrack files
post_crack_files = dir(fullfile(fullfile(pwd,...
    'PecanDataMaster','PecanData-images/Post_Crack'), '*.jpg'));

% number of pecans to consider
n_pecan_post_crack = length(post_crack_files);

% initialize double array of pre crack time stamps
time_stamps_post_crack = zeros(n_pecan_post_crack,1);

% get photo timestamps for pre crack files
for i = 1:n_pecan_post_crack
    time_stamps_post_crack(i) = str2double(extractBetween(...
        post_crack_files(i).name,'_','.'));
end

%% get uncracked files
uncracked_files = dir(fullfile(fullfile(pwd,...
    'PecanDataMaster','PecanData-images/Uncracked'), '*.jpg'));

% number of pecans to consider
n_pecan_uncracked = length(uncracked_files);

% initialize double array of pre crack time stamps
time_stamps_uncracked = zeros(n_pecan_uncracked,1);

% get photo timestamps for pre crack files
for i = 1:n_pecan_uncracked
    time_stamps_uncracked(i) = str2double(extractBetween(...
        uncracked_files(i).name,'_','.'));
end

%% get diseased files
diseased_files = dir(fullfile(fullfile(pwd,...
    'PecanDataMaster','PecanData-images/Diseased'), '*.jpg'));

% number of pecans to consider
n_pecan_diseased = length(diseased_files);

% initialize double array of pre crack time stamps
time_stamps_diseased = zeros(n_pecan_diseased,1);

% get photo timestamps for pre crack files
for i = 1:n_pecan_diseased
    time_stamps_diseased(i) = str2double(extractBetween(...
        diseased_files(i).name,'_','.'));
end

%% aggregate data

% array of timestamps for all files
time_stamps_aggregate = [time_stamps_pre_crack;time_stamps_post_crack;...
    time_stamps_uncracked;time_stamps_diseased];

% sorted time stamp array
[test, I_sort] = sort(time_stamps_aggregate);

% get array of post crack indices
I_sort_post_crack = zeros(n_pecan_post_crack,1);

for i = 1:n_pecan_post_crack
    I_sort_post_crack(i) = find(I_sort == (n_pecan_pre_crack+i));
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