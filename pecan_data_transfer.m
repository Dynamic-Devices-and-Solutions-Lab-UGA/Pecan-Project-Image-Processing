%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% After data has been 
%
% Author: Dani Agramonte
% Last Updated: 05.05.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialize MATLAB
clear; % Clear variables
clc;  % Clear command window.
workspace;  % Make sure the workspace panel is showing.

%% Post-Initialize MATLAB

% set path of where data is located
data_path = 'C:\Users\Dani\Documents\Pecan-Project-Image-Processing\Pecan_Data_Temp';
data_folder = 'Pecan_Data_Temp';

%% get all subfolders in PecanDataTemp

% get all folder contents

all_PecanDataMaster_contents = dir(data_path);

% remove files
PecanDataMaster_folders = all_PecanDataMaster_contents(...
    [all_PecanDataMaster_contents(:).isdir]);

% remove '.' and '..'
PecanDataMaster_folders = PecanDataMaster_folders(...
    ~ismember({PecanDataMaster_folders(:).name},{'.','..'}));

% empty array of values indicating if the file is an image file
isforcefile = zeros(size(PecanDataMaster_folders,1),1);

% determine if file is force or image file
for i = 1:size(PecanDataMaster_folders,1)
    isforcefile(i) = strcmp(...
        PecanDataMaster_folders(i).name(60:end),'converted');
end

%% get precrack files

% get pre crack files
% get size of pre crack file structure
n_image_folders = sum(~isforcefile);

% get indices where force files is nonzero
image_file_ind = find(~isforcefile);

% running sum of size of each subfolder
pc_files_running_sum = 0;

% build structure of pre crack files
for i = n_image_folders:-1:1
    % files for iteration
    pc_iter_files = dir(fullfile(...
        pwd,...
        data_folder,...
        PecanDataMaster_folders(image_file_ind(i)).name,...
        'Pre_Crack','*.jpg'));
    
    % n files for iteration
    n_pc_iter_files = size(pc_iter_files,1);
    
    % pre crack iteration start index
    pc_iter_si = 1+pc_files_running_sum;
    
    % pre_crack_iteration end index
    pc_iter_ei = pc_iter_si+n_pc_iter_files-1;
    
    % assign files to structure
    pre_crack_files(pc_iter_si:pc_iter_ei) = pc_iter_files;
    
    % update running sum
    pc_files_running_sum = pc_files_running_sum+n_pc_iter_files;
end

% number of pecans to consider
n_pecan_pre_crack = length(pre_crack_files);

% initialize double array of pre crack time stamps
time_stamps_pre_crack = zeros(n_pecan_pre_crack,1);

% get photo timestamps for pre crack files
for i = 1:n_pecan_pre_crack
    time_stamps_pre_crack(i) = time_unix(pre_crack_files(i).name);
end

% fix sorting
[time_stamps_pre_crack,I_pre_crack] = sort(time_stamps_pre_crack);
pre_crack_files = pre_crack_files(I_pre_crack);

%% get postcrack files

% get post crack files
% running sum of size of each subfolder
poc_files_running_sum = 0;

% build structure of post crack files
for i = n_image_folders:-1:1
    % files for iteration
    poc_iter_files = dir(fullfile(...
        pwd,...
        data_folder,...
        PecanDataMaster_folders(image_file_ind(i)).name,...
        'Post_Crack','*.jpg'));
    
    % n files for iteration
    n_poc_iter_files = size(poc_iter_files,1);
    
    % post crack iteration start index
    poc_iter_si = 1+poc_files_running_sum;
    
    % post_crack_iteration end index
    poc_iter_ei = poc_iter_si+n_poc_iter_files-1;
    
    % assign files to structure
    post_crack_files(poc_iter_si:poc_iter_ei) = poc_iter_files;
    
    % update running sum
    poc_files_running_sum = poc_files_running_sum+n_poc_iter_files;
end

% number of pecans to consider
n_pecan_post_crack = length(post_crack_files);

% initialize double array of pre crack time stamps
time_stamps_post_crack = zeros(n_pecan_post_crack,1);

% get photo timestamps for pre crack files
for i = 1:n_pecan_post_crack
    time_stamps_post_crack(i) = time_unix(post_crack_files(i).name);
end

% fix sorting
[time_stamps_post_crack,I_post_crack] = sort(time_stamps_post_crack);
post_crack_files = post_crack_files(I_post_crack);

%% get uncracked files

% get uncracked files
% running sum of size of each subfolder
uc_files_running_sum = 0;

% build structure of uncracked files
for i = n_image_folders:-1:1
    % files for iteration
    uc_iter_files = dir(fullfile(...
        pwd,...
        data_folder,...
        PecanDataMaster_folders(image_file_ind(i)).name,...
        'Uncracked','*.jpg'));
    
    % n files for iteration
    n_uc_iter_files = size(uc_iter_files,1);
    
    % uncracked iteration start index
    uc_iter_si = 1+uc_files_running_sum;
    
    % uncracked iteration end index
    uc_iter_ei = uc_iter_si+n_uc_iter_files-1;
    
    % assign files to structure
    uncracked_files(uc_iter_si:uc_iter_ei) = uc_iter_files;
    
    % update running sum
    uc_files_running_sum = uc_files_running_sum+n_uc_iter_files;
end

% number of pecans to consider
n_pecan_uncracked = length(uncracked_files);

% initialize double array of pre crack time stamps
time_stamps_uncracked = zeros(n_pecan_uncracked,1);

% get photo timestamps for pre crack files
for i = 1:n_pecan_uncracked
    time_stamps_uncracked(i) = time_unix(uncracked_files(i).name);
end

% fix sorting
[time_stamps_uncracked,I_uncracked] = sort(time_stamps_uncracked);
uncracked_files = uncracked_files(I_uncracked);

%% get diseased files

% get diseased files
% running sum of size of each subfolder
dd_files_running_sum = 0;

% build structure of diseased files
for i = n_image_folders:-1:1
    % files for iteration
    dd_iter_files = dir(fullfile(...
        pwd,...
        data_folder,...
        PecanDataMaster_folders(image_file_ind(i)).name,...
        'Diseased','*.jpg'));
    
    % n files for iteration
    n_dd_iter_files = size(dd_iter_files,1);
    
    % diseased iteration start index
    dd_iter_si = 1+dd_files_running_sum;
    
    % diseased iteration end index
    dd_iter_ei = dd_iter_si+n_dd_iter_files-1;
    
    % assign files to structure
    diseased_files(dd_iter_si:dd_iter_ei) = dd_iter_files;
    
    % update running sum
    dd_files_running_sum = dd_files_running_sum+n_dd_iter_files;
end

% number of pecans to consider
n_pecan_diseased = length(diseased_files);

% initialize double array of pre crack time stamps
time_stamps_diseased = zeros(n_pecan_diseased,1);

% get photo timestamps for pre crack files
for i = 1:n_pecan_diseased
    time_stamps_diseased(i) = time_unix(diseased_files(i).name);
end

% fix sorting
[time_stamps_diseased,I_diseased] = sort(time_stamps_diseased);
diseased_files = diseased_files(I_diseased);

%% load in data and initialize/preallocate arrays for force processing

% get force files
% get size of pre crack file structure
n_force_folders = sum(isforcefile);

% get indices where force files is nonzero
force_file_ind = find(isforcefile);

% running sum of size of each subfolder
fc_files_running_sum = 0;

% build structure of force files
for i = n_force_folders:-1:1
    % files for iteration
    fc_iter_files = dir(fullfile(...
        pwd,...
        data_folder,...
        PecanDataMaster_folders(force_file_ind(i)).name,'*.tdms'));
    
    % n files for iteration
    n_fc_iter_files = size(fc_iter_files,1);
    
    % force iteration start index
    fc_iter_si = 1+fc_files_running_sum;
    
    % force iteration end index
    fc_iter_ei = fc_iter_si+n_fc_iter_files-1;
    
    % assign files to structure
    force_files(fc_iter_si:fc_iter_ei) = fc_iter_files;
    
    % update running sum
    fc_files_running_sum = fc_files_running_sum+n_fc_iter_files;
end

% number of force files
n_force_files = length(force_files);

% initialize and preallocate
pecan_test_metadata = cell(n_force_files,1);
pecan_configuration_time = zeros(n_force_files,1);
pecan_test_time = zeros(n_force_files,1);
pecan_test_id = cell(n_force_files,1);

% calculate existing end index
force_end_ind = 0;

% get metadata for all force files
for i = 1:n_force_files
    pecan_test_metadata(i) = {force_files(i).name(24:71)};
    pecan_configuration_time(i) = time_unix(force_files(i).name(8:22));
    pecan_test_time(i) = time_unix(append(...
        force_files(i).name(8:16),...
        force_files(i).name(1:6)));
    pecan_test_id(i) = {force_files(i).name(73:82)};
end

% initialize/preallocate number of files deleted
n_delete = 0;

% delete weird data which appears at end of run
i = 1;
while true
    % delete entry if the size is incorrect
    if force_files(i).bytes<1e3
        % delete file
        delete(fullfile(force_files(i).folder,force_files(i).name));
        % remove tracking data
        force_files(i) = [];
        pecan_test_metadata(i) = [];
        pecan_configuration_time(i) = [];
        pecan_test_time(i) = [];
        pecan_test_id(i) = [];
        n_delete = n_delete+1;
    else
        i = i+1;
    end

    % if the index is the last index, break the statement
    if i > size(force_files,2)
        break
    end
end

% adjust size of force files
n_force_files = n_force_files-n_delete;

% sort force files
[~,I_sort_only_force] = sort(pecan_configuration_time);
force_files = force_files(I_sort_only_force);
pecan_test_metadata = pecan_test_metadata(I_sort_only_force);
pecan_configuration_time = pecan_configuration_time(I_sort_only_force);
pecan_test_time = pecan_test_time(I_sort_only_force);
pecan_test_id = pecan_test_id(I_sort_only_force);

% get unique values 
[pecan_test_meta_data_unique,i_meta_data] = unique(pecan_test_metadata,...
    'stable');

% array of timestamps for all files, including with force files
time_stamps_aggregate_force = [time_stamps_pre_crack;time_stamps_post_crack;...
    time_stamps_uncracked;time_stamps_diseased;pecan_test_time];

% array of sizes of different sections of sort array
n_pecan_sizes = [n_pecan_pre_crack;n_pecan_post_crack;n_pecan_uncracked;n_pecan_diseased;n_force_files];

% sorted time stamp array
[tsaf_sort, I_sort_force] = sort(time_stamps_aggregate_force);

%% delete files

% imported data from text file
imported_data = importdata('rows_manually_deleted.txt');

% initialize start/end ind matrix
se_ind = zeros(size(imported_data,1),2);

% read out data from text file
for i = 1:size(imported_data,1)
    temp = split(char(extractBetween(char(imported_data(i)),'(',')')),':');
    se_ind(i,1) = cellfun(@(x)str2double(x), temp(1));
    se_ind(i,2) = cellfun(@(x)str2double(x), temp(2));
    
    % loop from the start to the end index and delete everything
    for j = se_ind(i,1):se_ind(i,2)
        
        % calculate I_sort_force(j)
        isfj = I_sort_force(j);
        
        if isfj<=n_pecan_sizes(1)
            % get file to delete
            file_to_delete = fullfile(pre_crack_files(isfj).folder,pre_crack_files(isfj).name);
            % delete file
            delete(file_to_delete);
            % remove file from file structure
            pre_crack_files(isfj) = [];
            % shift pecan size
            n_pecan_sizes(1) = n_pecan_sizes(1)-1;
            n_pecan_pre_crack = n_pecan_pre_crack-1;
        elseif isfj<=sum(n_pecan_sizes(1:2))
            % calculate index
            ind = isfj - n_pecan_sizes(1);
            % get file to delete
            file_to_delete = fullfile(post_crack_files(ind).folder,post_crack_files(ind).name);
            % delete file
            delete(file_to_delete);
            % remove file from file structure
            post_crack_files(ind) = [];
            % shift pecan size
            n_pecan_sizes(2) = n_pecan_sizes(2)-1;
            n_pecan_post_crack = n_pecan_post_crack-1;
        elseif isfj<=sum(n_pecan_sizes(1:3))
            % calculate index
            ind = isfj - sum(n_pecan_sizes(1:2));
            % get file to delete
            file_to_delete = fullfile(uncracked_files(ind).folder,uncracked_files(ind).name);
            % delete file
            delete(file_to_delete);
            % remove file from file structure
            uncracked_files(ind) = [];
            % shift pecan size
            n_pecan_sizes(3) = n_pecan_sizes(3)-1;
            n_pecan_uncracked = n_pecan_uncracked-1;
        elseif isfj<=sum(n_pecan_sizes(1:4))
            % calculate index
            ind = isfj - sum(n_pecan_sizes(1:3));
            % get file to delete
            file_to_delete = fullfile(diseased_files(ind).folder,diseased_files(ind).name);
            % delete file
            delete(file_to_delete);
            % remove file from file structure
            diseased_files(ind) = [];
            % shift pecan size
            n_pecan_sizes(4) = n_pecan_sizes(4)-1;
            n_pecan_diseased = n_pecan_diseased-1;
        else
            % calculate index
            ind = isfj - sum(n_pecan_sizes(1:4));
            % get file to delete
            file_to_delete = fullfile(force_files(ind).folder,force_files(ind).name);
            % delete file
            delete(file_to_delete);
            % remove file from file structure
            force_files(ind) = [];
            % shift force size
            n_force_files = n_force_files-1;
        end
    end
end

%% move files over to Pecan_Data_Master

% image directory
image_directory = fullfile(pwd,'Pecan_Data_Master\Pecan_Data-images');

% pre crack destination
pre_crack_destination = fullfile(image_directory,'Pre_Crack');

% pre crack files
for i = 1:size(pre_crack_files,2)
    % get source file name 
    pre_crack_file_source = fullfile(pre_crack_files(i).folder,pre_crack_files(i).name);
    % move file
    movefile(pre_crack_file_source,pre_crack_destination);
end

% post crack destination
post_crack_destination = fullfile(image_directory,'Post_Crack');

% post crack files
for i = 1:size(post_crack_files,2)
    % get source file name 
    post_crack_file_source = fullfile(post_crack_files(i).folder,post_crack_files(i).name);
    % move file
    movefile(post_crack_file_source,post_crack_destination);
end

% uncracked destination
uncracked_destination = fullfile(image_directory,'Uncracked');

% uncracked files
for i = 1:size(uncracked_files,2)
    % get source file name 
    uncracked_file_source = fullfile(uncracked_files(i).folder,uncracked_files(i).name);
    % move file
    movefile(uncracked_file_source,uncracked_destination);
end

% diseased destination
diseased_destination = fullfile(image_directory,'Diseased');

% diseased files
for i = 1:size(diseased_files,2)
    % get source file name 
    diseased_file_source = fullfile(diseased_files(i).folder,diseased_files(i).name);
    % move file
    movefile(diseased_file_source,diseased_destination);
end

% force destination
force_destination = fullfile(pwd,'Pecan_Data_Master\Pecan_Data-force_files');

% force files
for i = 1:size(force_files,2)
    % get source file name 
    force_file_source = fullfile(force_files(i).folder,force_files(i).name);
    % move file
    movefile(force_file_source,force_destination);
end

%% Delete force files/trash

% running sum of size of each subfolder
fc_files_running_sum = 0;

% build structure of force files
for i = n_force_folders:-1:1
    % files for iteration
    fc_iter_files = dir(fullfile(...
        pwd,...
        data_folder,...
        PecanDataMaster_folders(force_file_ind(i)).name));
    
    % n files for iteration
    n_fc_iter_files = size(fc_iter_files,1);
    
    % force iteration start index
    fc_iter_si = 1+fc_files_running_sum;
    
    % force iteration end index
    fc_iter_ei = fc_iter_si+n_fc_iter_files-1;
    
    % assign files to structure
    force_files(fc_iter_si:fc_iter_ei) = fc_iter_files;
    
    % update running sum
    fc_files_running_sum = fc_files_running_sum+n_fc_iter_files;
end

% remove '.' and '..'
force_files([force_files.isdir]) = [];

% force files
for i = 1:size(force_files,2)
    % get source file name 
    force_file = fullfile(force_files(i).folder,force_files(i).name);
    % delete file
    delete(force_file);
end

% remove directories
for i = 1:size(PecanDataMaster_folders,1)
    if isforcefile
        rmdir(fullfile(PecanDataMaster_folders(i).folder,PecanDataMaster_folders(i).name));
    end
end

%% MATLAB closeup

% remove unnecessary paths for path cleaning
rmpath('C:\Users\Dani\Documents\Pecan-Project-Image-Processing\tdms');

clear; % Clear variables
clc;  % Clear command window.
workspace;  % Make sure the workspace panel is showing.