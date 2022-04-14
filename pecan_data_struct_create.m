%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Create data structure with all the important properties about a given
% pecan test run including metadata, test parameters, and results.
%
%
% TO DO:
% 1. Change how force files are processed to accomodate new file naming
% convention and to handle to handle the fact that the order of tests won't
% comply with ASCII ordering - DONE
% 2. save structure as a .mat file in a predicted location and delete all
% other variables to prevent clutter in the workspace - DONE
% 3. add a pre-processing component in the beginning to load existing
% structure in .mat form and append new data to it
% 4. add code to check that data going into structure seems correct/was
% collected correctly - especially for image processing stuff
% 5. figure out what fields to put in for nonstandard pecan cracking
% outcomes. 
%
% Author: Dani Agramonte
% Last Updated: 04.12.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialize MATLAB
clear; % Clear variables
clc;  % Clear command window.
workspace;  % Make sure the workspace panel is showing.

%% Prepare MATLAB

%load in existing structure to append to it if it exists
if exist('C:\Users\Dani\Documents\Pecan-Project-Image-Processing\PecanDataMaster\pecan_data_struct.mat','file')
    load('C:\Users\Dani\Documents\Pecan-Project-Image-Processing\PecanDataMaster\pecan_data_struct.mat')
end

% checks to see if tdms function is in current MATLAB path and adds it if
% it isn't in that path
if ~contains(path,'C:\Users\Dani\Documents\Pecan-Project-Image-Processing\tdms')
    addpath(genpath('C:\Users\Dani\Documents\Pecan-Project-Image-Processing\tdms'))
end

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

%% load in data and initialize/preallocate arrays for force processing

% get force files
force_files = dir(fullfile(fullfile(pwd,...
    'PecanDataMaster','PecanData-converted'), '*.tdms'));

% number of force files
n_force_files = length(force_files);

% initialize and preallocate
pecan_test_metadata = cell(n_force_files,1);
pecan_test_time = zeros(n_force_files,1);

% get metadata for all force files
for i = 1:n_force_files
    pecan_test_metadata(i) = {force_files(i).name(17:64)};
    
    % reformat string because LabVIEW prepended date as MMDDYYYY instead of
    % YYYYMMDD as expected
    string_reformat = append(force_files(i).name(5:8),...
        force_files(i).name(1:4),force_files(i).name(1:15));
    string_reformat(9:15) = [];
    pecan_test_time(i) = time_unix(string_reformat);
end

% get unique values 
[pecan_test_meta_data_unique,i_meta_data] = unique(pecan_test_metadata,'stable');


% initialize matrix with info about number of tests in each configuration
I_config_size = zeros(size(pecan_test_meta_data_unique,1),1);

% create pecan_data_struct and loop through number of testing 
% configurations
for i = 1:size(pecan_test_meta_data_unique,1)
    
    % get metadata from each configuration
    metadata = parsemetadata(pecan_test_meta_data_unique(i));
    pecan_data_struct(i).metadata = metadata; %#ok<SAGROW>
    
    % index for given configuration
    I_config = find(ismember(pecan_test_metadata,...
        pecan_test_meta_data_unique(i)));
    
    I_config_size(i) = size(I_config,1)-1;
    
    % loop through number of tests in each configuration
    for j = 1:(size(I_config,1)-1)
        
        % capture force and accel time histories as well as max force/accel
        [force,accel,max_force,max_accel] = force_accel_processing(...
            fullfile(force_files(I_config(j)).folder,...
            force_files(I_config(j)).name));
        
        % store data in struct
        pecan_data_struct(i).test(j).accelforce.force = force;
        pecan_data_struct(i).test(j).accelforce.accel = accel;
        pecan_data_struct(i).test(j).accelforce.maxforce = max_force;
        pecan_data_struct(i).test(j).accelforce.maxaccel = max_accel;
    end
end

%% get precrack files

pre_crack_files = dir(fullfile(fullfile(pwd,...
    'PecanDataMaster','PecanData-images/Pre_Crack'), '*.jpg'));

% number of pecans to consider
n_pecan_pre_crack = length(pre_crack_files);

% initialize double array of pre crack time stamps
time_stamps_pre_crack = zeros(n_pecan_pre_crack,1);

% get photo timestamps for pre crack files
for i = 1:n_pecan_pre_crack
    time_stamps_pre_crack(i) = time_unix(pre_crack_files(i).name);
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
    time_stamps_post_crack(i) = time_unix(post_crack_files(i).name);
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
    time_stamps_uncracked(i) = time_unix(uncracked_files(i).name);
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
    time_stamps_diseased(i) = time_unix(diseased_files(i).name);
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
I_config_size_running_sum = 0;

for i = 1:size(pecan_test_meta_data_unique,1)
    
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
                    
                    % populate structure
                    pecan_data_struct(i).test(j).post_crack_data.half(k-1).perc = perc;
                    pecan_data_struct(i).test(j).post_crack_data.half(k-1).post_crack_bw = post_crack_bw;
                    pecan_data_struct(i).test(j).post_crack_data.half(k-1).post_crack_area = post_crack_area;
                    
                    if k == 2
                        pecan_data_struct(i).test(j).pre_crack_data.pre_crack_bw = pre_crack_bw;
                        pecan_data_struct(i).test(j).pre_crack_data.pre_crack_area = pre_crack_area;
                        pecan_data_struct(i).test(j).result(k-1) = ...
                            {'Successful Crack'};
                    end
                                     
                elseif (((n_pecan_pre_crack+n_pecan_post_crack+1) ...
                        <= ind)&&((n_pecan_pre_crack+...
                        n_pecan_post_crack+n_pecan_uncracked) >= ind))
                    pecan_data_struct(i).test(j).result(k-1) = ...
                        {'Unsuccessful Crack'};
                    break
                elseif (((n_pecan_pre_crack+n_pecan_post_crack+...
                        n_pecan_uncracked+1) <= ind)&&((...
                        n_pecan_pre_crack+n_pecan_post_crack+...
                        n_pecan_uncracked+n_pecan_diseased) >= ind))
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
    I_config_size_running_sum = I_config_size_running_sum+I_config_size(i);
end

% save data structure
save('C:\Users\Dani\Documents\Pecan-Project-Image-Processing\PecanDataMaster\pecan_data_struct.mat','pecan_data_struct')

clearvars -except pecan_data_struct; % Clear variables
clc;  % Clear command window.
workspace;  % Make sure the workspace panel is showing.

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

function date = time_unix(string)
% time_unix: get string from picture files and return the time the picture
% was taken in unix time, i.e., time elapsed since midnight January 1st,
% 1970.

    % auxiliary variable to get first half of date info
    aux = strsplit(string,'_');
    
    % convert to character array
    yyyymmdd = char(aux(1));
    
    % relabel aux variable to get second half of date info
    aux = strsplit(char(aux(2)),'.');
    
    % convert to character array
    hhmmss = char(aux(1));
    date = convertTo(datetime(str2double(yyyymmdd(1:4)),...
        str2double(yyyymmdd(5:6)),str2double(yyyymmdd(7:8)),...
        str2double(hhmmss(1:2)),str2double(hhmmss(3:4)),...
        str2double(hhmmss(5:6))),'posixtime');

end % time_unix