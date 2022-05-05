%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Create I_sort structure to review all data and verify that it is good
% before it is moved into the pecan data master folder
%
% Author: Dani Agramonte
% Last Updated: 05.05.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialize MATLAB
tic; % begin timing script
clear; % Clear variables
clc;  % Clear command window.
workspace;  % Make sure the workspace panel is showing.

%% Post-Initialize MATLAB


% checks to see if tdms function is in current MATLAB path and adds it if
% it isn't in that path
addpath(genpath('C:\Users\Dani\Documents\Pecan-Project-Image-Processing\tdms'))

% set path of where data is located
data_path = 'C:\Users\Dani\Documents\Pecan-Project-Image-Processing\Pecan_Data_Temp';
data_folder = 'Pecan_Data_Temp';

% ======================================================================= %
% Turn off note "Warning: Added specified worksheet." that appears in the 
% command window. To set the warning state, you must first know the 
% message identifier for the one warning you want to enable. 
% Query the last warning to acquire the identifier.  
% 
% For example: 
% warnStruct = warning('query', 'last');
% msgid_integerCat = warnStruct.identifier
% 
% Command window will show this:
% msgid_integerCat =
%    MATLAB:xlswrite:AddSheet
% 
% You need to pass the expression with the colons in it into the warning() 
% function.
%
% Turn off note "Warning: Added specified worksheet." that appears in the 
% command window.
% ======================================================================= %

if(~isdeployed)
  cd(fileparts(which(mfilename)));
end

%% get all subfolders in PecanDataMaster

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
n_force_files = sum(isforcefile);

% get indices where force files is nonzero
force_file_ind = find(isforcefile);

% running sum of size of each subfolder
fc_files_running_sum = 0;

% build structure of force files
for i = n_force_files:-1:1
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

% sorted time stamp array
[tsaf_sort, I_sort_force] = sort(time_stamps_aggregate_force);

%% create summary structure

for i = size(I_sort_force,1):-1:1
    % populate summary structure
    new_data_summ(i).I_sort_ind = I_sort_force(i);
    new_data_summ(i).time = stand_time(tsaf_sort(i));
    
    if I_sort_force(i)<=n_pecan_pre_crack
        new_data_summ(i).desc = 'pre crack image';
    elseif I_sort_force(i)<=n_pecan_pre_crack+n_pecan_post_crack
        new_data_summ(i).desc = 'post crack image';
    elseif I_sort_force(i)<=n_pecan_pre_crack+n_pecan_post_crack+n_pecan_uncracked
        new_data_summ(i).desc = 'uncracked';
    elseif I_sort_force(i)<=n_pecan_pre_crack+n_pecan_post_crack+n_pecan_uncracked+n_pecan_diseased
        new_data_summ(i).desc = 'diseased';
    else
        new_data_summ(i).desc = 'force file';
        new_data_summ(i).metadata = pecan_test_metadata(I_sort_force(i)-(n_pecan_pre_crack+n_pecan_post_crack+n_pecan_uncracked+n_pecan_diseased));
        new_data_summ(i).id = pecan_test_id(I_sort_force(i)-(n_pecan_pre_crack+n_pecan_post_crack+n_pecan_uncracked+n_pecan_diseased));
    end
end

%% Delete bad data

% insert rows which are manually selected
new_data_summ(780:782) = [];
new_data_summ(742:748) = [];
new_data_summ(705:711) = [];
new_data_summ(665:672) = [];
new_data_summ(625:632) = [];
new_data_summ(585:592) = [];
new_data_summ(545:552) = [];
new_data_summ(505:512) = [];
new_data_summ(465:472) = [];
new_data_summ(426:432) = [];
new_data_summ(390:395) = [];
new_data_summ(379:382) = [];
new_data_summ(341:346) = [];
new_data_summ(341:346) = [];
new_data_summ(298:305) = [];
new_data_summ(257:265) = [];
new_data_summ(210:218) = [];
new_data_summ(161:167) = [];
new_data_summ(115:121) = [];
new_data_summ(73:77) = [];
new_data_summ(66:68) = [];
new_data_summ(1:37) = [];

%% Make sure ordering is correct

for i = 1:size(new_data_summ,2)
    if i == 1
        if ~strcmp(new_data_summ(i).desc,'pre crack image')
            disp('first entry should be a pre crack image')
            disp(i)
            break
        end
    else
        if strcmp(new_data_summ(i).desc,'force file')
            if ~strcmp(new_data_summ(i-1).desc,'pre crack image')
                disp('a force file must always follow a pre crack image')
                disp(i)
                break
            elseif ~((strcmp(new_data_summ(i+1).desc,'post crack image'))||(strcmp(new_data_summ(i+1).desc,'diseased'))||(strcmp(new_data_summ(i+1).desc,'uncracked')))
                disp('either a post crack image, a diseased image, or an uncracked image must follow a force file')
                disp(i)
                break
            end
        elseif strcmp(new_data_summ(i).desc,'post crack image')
            if (~strcmp(new_data_summ(i-1).desc,'force file'))&&(~strcmp(new_data_summ(i-1).desc,'post crack image'))
                disp('a post crack image must always follow a force file unless it''s the second post crack image in a row')
                disp(i)
                break
            elseif (strcmp(new_data_summ(i-1).desc,'post crack image'))&&(strcmp(new_data_summ(i-1).desc,'pre crack image'))
                disp('if the previous image is a post crack image, the following image must be a post crack image')
                break
            end
        elseif strcmp(new_data_summ(i).desc,'diseased')
            if (~strcmp(new_data_summ(i-1).desc,'force file'))
                disp('a force file must precede a diseased image')
                disp(i)
                break
            elseif (~strcmp(new_data_summ(i+1).desc,'pre crack image'))
                disp('a pre crack image must follow a diseased image')
                disp(i)
                break
            end
        elseif strcmp(new_data_summ(i).desc,'pre crack image')
            if ~((strcmp(new_data_summ(i-1).desc,'post crack image'))||(strcmp(new_data_summ(i-1).desc,'diseased'))||(strcmp(new_data_summ(i-1).desc,'uncracked')))
                disp('either a post crack image, a diseased image, or an uncracked image must precede a pre crack image')
                disp(i)
                break
            elseif (~strcmp(new_data_summ(i+1).desc,'force file'))
                disp('a force file must follow a pre crack image')
                disp(i)
                break
            end
        else
            if (~strcmp(new_data_summ(i-1).desc,'force file'))
                disp('a force file must precede an uncracked image')
                disp(i)
                break
            elseif (~strcmp(new_data_summ(i+1).desc,'pre crack image'))
                disp('a pre crack image must follow an uncracked image')
                disp(i)
                break
            end
        end     
    end
end