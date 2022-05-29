%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Create data structure with all the important properties about a given
% pecan test run including metadata, test parameters, and results.
%
% Second processing script
% pecan_data_clean -> pecan_data_struct_create
%
% Author: Dani Agramonte
% Last Updated: 05.29.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialize MATLAB
tic; % begin timing script

clear variables; % Clear variables
clear('textprogressbar'); % clear persistent vars in textprogressbar
workspace;  % Make sure the workspace panel is showing.
commandwindow();

%% Post-Initialize MATLAB

% set path of where data is located
data_path = 'C:\Users\Dani\Documents\Pecan-Project-Image-Processing\Pecan_Data_Master';

% load in info about valid files
load('C:\Users\Dani\Documents\Pecan-Project-Image-Processing\Pecan_Data_Master\DataStatus','ver_summary_struct')

%% load in info from ver_summary_struct

% get all types from summary struct
types_agg = {ver_summary_struct(:).desc};

% get indices
pre_crack_inds = find(strcmp(types_agg, 'pre crack image'));
post_crack_inds = find(strcmp(types_agg, 'post crack image'));
force_inds = find(strcmp(types_agg, 'force file'));
uncracked_inds = find(strcmp(types_agg, 'uncracked'));

%% get precrack files

% number of pecans to consider
n_pecan_pre_crack = numel(pre_crack_inds);

for i = n_pecan_pre_crack:-1:1
    pre_crack_files(i).folder = ver_summary_struct(pre_crack_inds(i)).folder;
    pre_crack_files(i).name = ver_summary_struct(pre_crack_inds(i)).filename;
    
end

% initialize double array of pre crack time stamps
time_stamps_pre_crack = zeros(n_pecan_pre_crack,1);

% get photo timestamps for pre crack files
for i = 1:n_pecan_pre_crack
    time_stamps_pre_crack(i) = time_unix(pre_crack_files(i).name);
end

%% get postcrack files

% number of pecans to consider
n_pecan_post_crack = numel(post_crack_inds);

for i = n_pecan_post_crack:-1:1
    post_crack_files(i).folder = ver_summary_struct(post_crack_inds(i)).folder;
    post_crack_files(i).name = ver_summary_struct(post_crack_inds(i)).filename;
    
end

% initialize double array of pre crack time stamps
time_stamps_post_crack = zeros(n_pecan_post_crack,1);

% get photo timestamps for pre crack files
for i = 1:n_pecan_post_crack
    time_stamps_post_crack(i) = time_unix(post_crack_files(i).name);
end

%% get uncracked files

% number of pecans to consider
n_pecan_uncracked = numel(uncracked_inds);

for i = n_pecan_uncracked:-1:1
    uncracked_files(i).folder = ver_summary_struct(uncracked_inds(i)).folder;
    uncracked_files(i).name = ver_summary_struct(uncracked_inds(i)).filename;
    
end

% initialize double array of pre crack time stamps
time_stamps_uncracked = zeros(n_pecan_uncracked,1);

% get photo timestamps for pre crack files
for i = 1:n_pecan_uncracked
    time_stamps_uncracked(i) = time_unix(uncracked_files(i).name);
end

%% load in data and initialize/preallocate arrays for force processing

% number of pecans to consider
n_force_files = numel(force_inds);

for i = n_force_files:-1:1
    force_files(i).folder = ver_summary_struct(force_inds(i)).folder;
    force_files(i).name = ver_summary_struct(force_inds(i)).filename;
    
end

% initialize double array of pre crack time stamps
time_stamps_force = zeros(n_force_files,1);

% get photo timestamps for pre crack files
for i = 1:n_force_files
    time_stamps_force(i) = time_unix(force_files(i).name);
end

% initialize and preallocate
pecan_test_metadata = cell(n_force_files,1);
pecan_configuration_time = zeros(n_force_files,1);
pecan_test_time = zeros(n_force_files,1);
pecan_test_id = cell(n_force_files,1);

% calculate existing end index
force_end_ind = 0;

% get metadata for all force files
for i = 1:n_force_files
    
    % parse force file name
    force_name_parse = strsplit(force_files(i).name,'-');
    
    % set pecan configation time
    pecan_configuration_time(i) = time_unix(char(force_name_parse{2}));
    
    % parse pecan configuration time
    pct_parse = strsplit(char(force_name_parse{2}),'_');
    
    % get pecan test time
    s = {char(pct_parse{1}),force_name_parse{1}};
    pecan_test_time(i) = time_unix([sprintf('%s_',s{1:end-1}),s{end}]);
    
    s = {force_name_parse{3},force_name_parse{4},force_name_parse{5},force_name_parse{6}};
    pecan_test_metadata(i) = {[sprintf('%s-',s{1:end-1}),s{end}]};
    pecan_test_id(i) = {force_name_parse(7)};
end

% get unique values 
[pecan_test_meta_data_unique,~] = unique(pecan_test_metadata,'stable');

% initialize matrix with info about number of tests in each configuration
I_config_size = zeros(size(pecan_test_meta_data_unique,1),1);

% create pecan_data_struct and loop through number of testing 
% configurations
textprogressbar(pad('loading in force data:',60));
for i = (size(pecan_test_meta_data_unique,1)):-1:1
    textprogressbar(100-100*(i/size(pecan_test_meta_data_unique,1)),'backwards');
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
        [force,max_force] = force_accel_processing(...
            fullfile(force_files(I_config(j)).folder,...
            force_files(I_config(j)).name));
        
        % store data in struct
        pecan_data_struct(i).test(j).accelforce.force = force;
        pecan_data_struct(i).test(j).accelforce.maxforce = max_force;
        pecan_data_struct(i).test(j).accelforce.file = fullfile(...
            force_files(I_config(j)).folder,force_files(I_config(j)).name);
    end
end
textprogressbar('terminated');

%% aggregate data

% array of timestamps for all files
time_stamps_aggregate = [time_stamps_pre_crack;time_stamps_post_crack;...
    time_stamps_uncracked];

% sorted time stamp array 
[~, I_sort] = sort(time_stamps_aggregate);


% initialize sum of I_config_size
I_config_size_running_sum = sum(I_config_size(1:(end-1)));

textprogressbar(pad('creating pecan data structure:',60));
for i = (size(pecan_test_meta_data_unique,1)):-1:1
    textprogressbar(100-100*(i/size(pecan_test_meta_data_unique,1)),'backwards');
    
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
                    +n_pecan_post_crack+n_pecan_uncracked
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
                    [perc,~,~,~,~,pre_crack_area,post_crack_area] = ...
                        PHE(pecan_data_struct(i).test(j).pre_crack_data.file,...
                        pecan_data_struct(i).test(j).post_crack_data.half(k-1).file);
                    
                    if k == 2
                        pecan_data_struct(i).test(j).result(k-1) = ...
                            {'Successful Crack'};
                        pecan_data_struct(i).test(j).pre_crack_data.pre_crack_area = pre_crack_area;
                    end
                    
                    % populate structure
                    pecan_data_struct(i).test(j).post_crack_data.half(k-1).perc = perc;
                    pecan_data_struct(i).test(j).post_crack_data.half(k-1).post_crack_area = post_crack_area;
                                     
                elseif (((n_pecan_pre_crack+n_pecan_post_crack+1) ...
                        <= ind)&&((n_pecan_pre_crack+...
                        n_pecan_post_crack+n_pecan_uncracked) >= ind))
                    
                    % calculate uncracked ind
                    uncracked_ind = ind-n_pecan_pre_crack-n_pecan_post_crack;
                    
                    % get file and store in structure
                    pecan_data_struct(i).test(j).post_crack_data.half(k-1).file = ...
                        fullfile(uncracked_files(uncracked_ind).folder,...
                        uncracked_files(uncracked_ind).name);
                    
                    % calculate pecan data for half
                    [~,~,~,~,~,pre_crack_area,~] = ...
                        PHE(pecan_data_struct(i).test(j).pre_crack_data.file,...
                        pecan_data_struct(i).test(j).post_crack_data.half(k-1).file);
                    
                    if k == 2
                        pecan_data_struct(i).test(j).result(k-1) = ...
                            {'Unsuccessful Crack'};
                        pecan_data_struct(i).test(j).pre_crack_data.pre_crack_area = pre_crack_area;
                    end
                    
                    % populate structure
                    pecan_data_struct(i).test(j).post_crack_data.half(k-1).perc = 0;
                    pecan_data_struct(i).test(j).post_crack_data.half(k-1).post_crack_area = 0;
                    pecan_data_struct(i).test(j).post_crack_data.half(k).perc = 0;
                    pecan_data_struct(i).test(j).post_crack_data.half(k).post_crack_area = 0;
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
textprogressbar('terminated');

%% finalization

% save data structure
save(fullfile(data_path,'pecan_data_struct.mat'),'pecan_data_struct')
clearvars -except pecan_data_struct; % Clear variables
clc;  % Clear command window.
workspace;  % Make sure the workspace panel is showing.

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