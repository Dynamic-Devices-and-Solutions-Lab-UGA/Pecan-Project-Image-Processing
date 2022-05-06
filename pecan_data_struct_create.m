%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Create data structure with all the important properties about a given
% pecan test run including metadata, test parameters, and results.
%
% Third processing script
% pecan_data_clean -> pecan_data_transfer -> pecan_data_struct_create
%
% Author: Dani Agramonte
% Last Updated: 05.06.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialize MATLAB
tic; % begin timing script
clear; % Clear variables
clc;  % Clear command window.
workspace;  % Make sure the workspace panel is showing.

%% Post-Initialize MATLAB

%load in existing structure to append to it if it exists and create flag if
%it does exist
params.pecan_data_struct_preexist = 0;
if exist('C:\Users\Dani\Documents\Pecan-Project-Image-Processing\Pecan_Data_Master\pecan_data_struct.mat','file')~=0
    load('C:\Users\Dani\Documents\Pecan-Project-Image-Processing\Pecan_Data_Master\pecan_data_struct.mat')
    params.pecan_data_struct_preexist = 1;
end

% checks to see if tdms function is in current MATLAB path and adds it if
% it isn't in that path
addpath(genpath('C:\Users\Dani\Documents\Pecan-Project-Image-Processing\tdms'))

% set path of where data is located
data_path = 'C:\Users\Dani\Documents\Pecan-Project-Image-Processing\Pecan_Data_Master';

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

%% obtain data from pecan_data_struct if it exists

if params.pecan_data_struct_preexist
    % unix timestamp for final force in existing struct
    [~,force_final_name] = fileparts(pecan_data_struct(end).test(end).accelforce.file);
    final_data_existing_timestamp = time_unix(force_final_name(8:22));
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
n_image_files = sum(~isforcefile);

% get indices where force files is nonzero
image_file_ind = find(~isforcefile);

% running sum of size of each subfolder
pc_files_running_sum = 0;

% build structure of pre crack files
for i = n_image_files:-1:1
    % files for iteration
    pc_iter_files = dir(fullfile(...
        pwd,...
        'Pecan_Data_Master',...
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
for i = n_image_files:-1:1
    % files for iteration
    poc_iter_files = dir(fullfile(...
        pwd,...
        'Pecan_Data_Master',...
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
for i = n_image_files:-1:1
    % files for iteration
    uc_iter_files = dir(fullfile(...
        pwd,...
        'Pecan_Data_Master',...
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
for i = n_image_files:-1:1
    % files for iteration
    dd_iter_files = dir(fullfile(...
        pwd,...
        'Pecan_Data_Master',...
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
        'Pecan_Data_Master',...
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

% calculate existing end index
force_end_ind = 0;

% get metadata for all force files
for i = 1:n_force_files
    pecan_test_metadata(i) = {force_files(i).name(24:71)};
    pecan_configuration_time(i) = time_unix(force_files(i).name(8:22));
    pecan_test_time(i) = time_unix(append(...
        force_files(i).name(8:16),...
        force_files(i).name(1:6)));
end

% sort force files
[~,I_sort_only_force] = sort(pecan_configuration_time);
force_files = force_files(I_sort_only_force);
pecan_test_metadata = pecan_test_metadata(I_sort_only_force);
pecan_configuration_time = pecan_configuration_time(I_sort_only_force);
pecan_test_time = pecan_test_time(I_sort_only_force);

% get unique values 
[pecan_test_meta_data_unique,i_meta_data] = unique(pecan_test_metadata,...
    'stable');

% array of timestamps for all files, including with force files
time_stamps_aggregate_force = [time_stamps_pre_crack;time_stamps_post_crack;...
    time_stamps_uncracked;time_stamps_diseased;pecan_test_time];

% sorted time stamp array
[~, I_sort_force] = sort(time_stamps_aggregate_force);

% parameters
n_images = n_pecan_pre_crack+n_pecan_post_crack+n_pecan_diseased+...
    n_pecan_uncracked;

% initialize/preallocate number of files deleted
n_delete = 0;

% delete weird data which sometimes appears at the end of a testing
% configuration
i = 1;
while true
    % delete entry if the size is incorrect
    if force_files(i).bytes<1e3
        force_files(i) = [];
        pecan_test_metadata(i) = [];
        n_delete = n_delete+1;
    else
        i = i+1;
    end
    
    % if the index is the last index, break the statement
    if i > size(force_files,2)
        break
    end
end

% initialize matrix with info about number of tests in each configuration
I_config_size = zeros(size(pecan_test_meta_data_unique,1),1);

% create pecan_data_struct and loop through number of testing 
% configurations
for i = (size(pecan_test_meta_data_unique,1)):-1:1
    % check to see if data has been loaded
    if params.pecan_data_struct_preexist
        if pecan_configuration_time(i_meta_data(i)) <= final_data_existing_timestamp
            continue
        end
    end
    
    % get metadata from each configuration
    metadata = parsemetadata(pecan_test_meta_data_unique(i));
    pecan_data_struct(i).metadata = metadata;
    
    % index for given configuration
    I_config = find(ismember(pecan_test_metadata,...
        pecan_test_meta_data_unique(i)));
    
    I_config_size(i) = size(I_config,1);
    
    % loop through number of tests in each configuration
    for j = 1:(size(I_config,1))
        
        % capture force and accel time histories as well as max force/accel
        [force,accel,max_force,max_accel] = force_accel_processing(...
            fullfile(force_files(I_config(j)).folder,...
            force_files(I_config(j)).name));
        
        % store data in struct
        pecan_data_struct(i).test(j).accelforce.force = force;
        pecan_data_struct(i).test(j).accelforce.accel = accel;
        pecan_data_struct(i).test(j).accelforce.maxforce = max_force;
        pecan_data_struct(i).test(j).accelforce.maxaccel = max_accel;
        pecan_data_struct(i).test(j).accelforce.file = fullfile(...
            force_files(I_config(j)).folder,force_files(I_config(j)).name);
    end
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

% initialize sum of I_config_size
I_config_size_running_sum = sum(I_config_size(1:(end-1)));

for i = (size(pecan_test_meta_data_unique,1)):-1:1
    
    % continue if the data has already been logged in the .mat file
    if params.pecan_data_struct_preexist
        if pecan_configuration_time(i_meta_data(i)) <= final_data_existing_timestamp
            if i>1
                I_config_size_running_sum = ...
                    I_config_size_running_sum-I_config_size(i-1);
            end
            continue
        end
    end
    
    % find pre crack indices in sorted list
    all_pre_crack_ind_i = find(sum(I_sort == ...
        ((I_config_size_running_sum+1):(I_config_size_running_sum+...
        I_config_size(i))),2));
    
    for j = 1:I_config_size(i)
        % get pre crack index
        pre_crack_ind = I_config_size_running_sum+j;
        
        % get and store pre crack file
        pecan_data_struct(i).test(j).pre_crack_data.file = fullfile(...
        pre_crack_files(pre_crack_ind).folder,...
        pre_crack_files(pre_crack_ind).name);
    
        % initialize indexing variable
        k = 1;
        while true
            % check to see if ind is in bounds 
            if all_pre_crack_ind_i(j)+k <= n_pecan_pre_crack...
                    +n_pecan_post_crack+n_pecan_uncracked+n_pecan_diseased
                % figure out what the next image is
                ind = I_sort(all_pre_crack_ind_i(j)+k);
                
                % iterate to the next image
                k = k+1;
                
                if (((n_pecan_pre_crack+1) <= ind)&&...
                        ((n_pecan_pre_crack+n_pecan_post_crack) >= ind))
                    
                    % calculate post crack index
                    post_crack_ind = ind-n_pecan_pre_crack;
                    
                    % get post crack file
                    pecan_data_struct(i).test(j).post_crack_data.half(k-1).file = ...
                        fullfile(post_crack_files(post_crack_ind).folder,...
                        post_crack_files(post_crack_ind).name);
                    
                    % calculate pecan data for half
                    [perc,~,~,pre_crack_bw,post_crack_bw,...
                        pre_crack_area,post_crack_area] = ...
                        PHE(pecan_data_struct(i).test(j).pre_crack_data.file,...
                        pecan_data_struct(i).test(j).post_crack_data.half(k-1).file);
                    
                    if k == 2
                        pecan_data_struct(i).test(j).result(k-1) = ...
                            {'Successful Crack'};
                        pecan_data_struct(i).test(j).pre_crack_data.pre_crack_bw = pre_crack_bw;
                        pecan_data_struct(i).test(j).pre_crack_data.pre_crack_area = pre_crack_area;
                    end
                    
                    % populate structure
                    pecan_data_struct(i).test(j).post_crack_data.half(k-1).perc = perc;
                    pecan_data_struct(i).test(j).post_crack_data.half(k-1).post_crack_bw = post_crack_bw;
                    pecan_data_struct(i).test(j).post_crack_data.half(k-1).post_crack_area = post_crack_area;
                                     
                elseif (((n_pecan_pre_crack+n_pecan_post_crack+1) ...
                        <= ind)&&((n_pecan_pre_crack+...
                        n_pecan_post_crack+n_pecan_uncracked) >= ind))
                    
                    % calculate uncracked ind
                    uncracked_ind = ind-n_pecan_pre_crack-n_pecan_post_crack;
                    
                    % get file and store in structure
                    pecan_data_struct(i).test(j).post_crack_data.file = ...
                        fullfile(uncracked_files(uncracked_ind).folder,...
                        uncracked_files(uncracked_ind).name);
                    
                    % populate rest of structure
                    pecan_data_struct(i).test(j).post_crack_data.perc = 0;
                    pecan_data_struct(i).test(j).post_crack_data.post_crack_area = 0;
                    
                    pecan_data_struct(i).test(j).result(k-1) = ...
                        {'Unsuccessful Crack'};
                    break
                elseif (((n_pecan_pre_crack+n_pecan_post_crack+...
                        n_pecan_uncracked+1) <= ind)&&((...
                        n_pecan_pre_crack+n_pecan_post_crack+...
                        n_pecan_uncracked+n_pecan_diseased) >= ind))
                    
                    % calculate diseased ind
                    diseased_ind = ind-n_pecan_pre_crack-n_pecan_post_crack-n_pecan_uncracked;
                    
                    % get file and store in structure
                    pecan_data_struct(i).test(j).post_crack_data.file = ...
                        fullfile(diseased_files(diseased_ind).folder,...
                        diseased_files(diseased_ind).name);
                    
                    pecan_data_struct(i).test(j).result(k-1) = ...
                        {'Diseased Pecan'};
                    break
                elseif (1 <= ind)&&(n_pecan_pre_crack >= ind)
                    break
                else
                end
            else
                break
            end
        end
    end
    if i>1
        I_config_size_running_sum = I_config_size_running_sum-I_config_size(i-1);
    end
end

%% finalization

% save data structure
save(fullfile(data_path,'pecan_data_struct.mat'),'pecan_data_struct')
clearvars -except pecan_data_struct; % Clear variables
clc;  % Clear command window.
workspace;  % Make sure the workspace panel is showing.

% remove unnecessary paths for path cleaning
rmpath('C:\Users\Dani\Documents\Pecan-Project-Image-Processing\tdms');

% finish timing of script
elapsed_time = toc;

%-----------END MAIN SCTIPT-----------%

function [metadata] = parsemetadata(val)
% parsemetadata: get metadata from 

% Cell array of metadata property names
properties = {'Angle', 'Height', 'Mass','Material'};

% use '-' delimeters to split metadata
val_split = strsplit(char(val),'-');

% initialize metadata structure
metadata = [];

for i = 1:4
    for j = 1:4
        if sum(strcmpi(strsplit(char(val_split(i)),'.'),properties(j)))>0
            if ismember('Material',properties(j))
                % pop off property for Material
                temp = char(val_split(i));
                metadata.(properties{j}) = ...
                    temp((length(char(properties(j)))+2):end);
            else
                % pop off property for all other properties and convert to
                % number
                temp = char(val_split(i));
                metadata.(properties{j}) = str2double(temp(...
                    (length(char(properties(j)))+2):end));
            end
        end
    end
end

end % parsemetadata