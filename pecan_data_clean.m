%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Create I_sort structure to review all data and verify that it is good
% before it is moved into the pecan data master folder
%
% First processing script
% pecan_data_clean -> -> pecan_data_struct_create
%
% Author: Dani Agramonte
% Last Updated: 05.06.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialize MATLAB
clear; % Clear variables
clc;  % Clear command window.
workspace;  % Make sure the workspace panel is showing.

%% Post-Initialize MATLAB

% set path of where data is located
data_path = ['C:\Users\Dani\Documents\Pecan-Project-Image-Processing\'...
    'Pecan_Data_Temp'];
data_folder = 'Pecan_Data_Temp';

%% get precrack files

% assign files to structure
pre_crack_files = dir(fullfile(...
    data_path,...
    'Pecan_Data-Image_Files',...
    'Pre_Crack','*.jpg'));

% number of pecans to consider
n_pecan_pre_crack = numel(pre_crack_files);

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

% assign files to structure
post_crack_files = dir(fullfile(...
    data_path,...
    'Pecan_Data-Image_Files',...
    'Post_Crack','*.jpg'));

% number of pecans to consider
n_pecan_post_crack = numel(post_crack_files);

% initialize double array of pre crack time stamps
time_stamps_post_crack = zeros(n_pecan_post_crack,1);

% get photo timestamps for post crack files
for i = 1:n_pecan_post_crack
    time_stamps_post_crack(i) = time_unix(post_crack_files(i).name);
end

% fix sorting
[time_stamps_post_crack,I_post_crack] = sort(time_stamps_post_crack);
post_crack_files = post_crack_files(I_post_crack);

%% get uncracked files

% assign files to structure
uncracked_files = dir(fullfile(...
    data_path,...
    'Pecan_Data-Image_Files',...
    'Uncracked','*.jpg'));

% number of pecans to consider
n_pecan_uncracked = numel(uncracked_files);

% initialize double array of post crack time stamps
time_stamps_uncracked = zeros(n_pecan_uncracked,1);

% get photo timestamps for post crack files
for i = 1:n_pecan_uncracked
    time_stamps_uncracked(i) = time_unix(uncracked_files(i).name);
end

% fix sorting
[time_stamps_uncracked,I_uncracked] = sort(time_stamps_uncracked);
uncracked_files = uncracked_files(I_uncracked);

%% get diseased files

% assign files to structure
diseased_files = dir(fullfile(...
    data_path,...
    'Pecan_Data-Image_Files',...
    'Diseased','*.jpg'));

% number of pecans to consider
n_pecan_diseased = numel(diseased_files);

% initialize double array of diseased time stamps
time_stamps_diseased = zeros(n_pecan_diseased,1);

% get photo timestamps for diseased files
for i = 1:n_pecan_diseased
    time_stamps_diseased(i) = time_unix(diseased_files(i).name);
end

% fix sorting
[time_stamps_diseased,I_diseased] = sort(time_stamps_diseased);
diseased_files = diseased_files(I_diseased);

%% load in data and initialize/preallocate arrays for force processing

% initial dir call
force_folders = dir(fullfile(data_path,'Pecan_Data-Force_Files'));

% remove '.' and '..'
force_folders = force_folders(~ismember({force_folders.name},{'.','..'}));

% get number of force folders
n_force_folders = numel(force_folders);

% running sum of size of each subfolder
fc_files_running_sum = 0;

% build structure of force files
for i = 1:n_force_folders
    
    % files for iteration
    fc_iter_files = dir(fullfile(...
        data_path,...
        'Pecan_Data-Force_Files',...
        force_folders(i).name,'*.tdms'));
    
    % n files for iteration
    n_fc_iter_files = numel(fc_iter_files);
    
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
n_force_files = numel(force_files);

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
[pecan_test_time,I_sort_only_force] = sort(pecan_test_time);
force_files = force_files(I_sort_only_force);
pecan_test_metadata = pecan_test_metadata(I_sort_only_force);
pecan_configuration_time = pecan_configuration_time(I_sort_only_force);

% get unique values 
[pecan_test_meta_data_unique,i_meta_data] = unique(pecan_test_metadata,...
    'stable');

% array of timestamps for all files, including with force files
time_stamps_aggregate_force = [time_stamps_pre_crack;time_stamps_post_crack;...
    time_stamps_uncracked;time_stamps_diseased;pecan_test_time];

% sorted time stamp array
[tsaf_sort, I_sort_force] = sort(time_stamps_aggregate_force);

%% create summary structure

textprogressbar(pad('creating summary structure:',60));
for i = size(I_sort_force,1):-1:1
    textprogressbar(100-100*(i/size(I_sort_force,1)),'backwards');
    % populate summary structure
    summary_struct(i).I_sort_ind = I_sort_force(i);
    summary_struct(i).time = stand_time(tsaf_sort(i));
    
    if I_sort_force(i)<=n_pecan_pre_crack
        summary_struct(i).desc = 'pre crack image';
        
        % calculate index
        ind = I_sort_force(i);
        
        % set paths to structure
        summary_struct(i).filename = pre_crack_files(ind).name;
        summary_struct(i).folder = pre_crack_files(ind).folder;
        
    elseif I_sort_force(i)<=n_pecan_pre_crack+n_pecan_post_crack
        summary_struct(i).desc = 'post crack image';
        
        % calculate index
        ind = I_sort_force(i)-n_pecan_pre_crack;
        
        % set paths to structure
        summary_struct(i).filename = post_crack_files(ind).name;
        summary_struct(i).folder = post_crack_files(ind).folder;
        
    elseif I_sort_force(i)<=n_pecan_pre_crack+n_pecan_post_crack+...
            n_pecan_uncracked
        summary_struct(i).desc = 'uncracked';
        
        % calculate index
        ind = I_sort_force(i)-n_pecan_pre_crack-n_pecan_post_crack;
        
        % set paths to structure
        summary_struct(i).filename =  uncracked_files(ind).name;
        summary_struct(i).folder = uncracked_files(ind).folder;
        
    elseif I_sort_force(i)<=n_pecan_pre_crack+n_pecan_post_crack+...
            n_pecan_uncracked+n_pecan_diseased
        summary_struct(i).desc = 'diseased';
        
        % calculate index
        ind = I_sort_force(i)-n_pecan_pre_crack-n_pecan_post_crack-n_pecan_uncracked;
        
        % set paths to structure
        summary_struct(i).filename = pre_crack_files(ind).name;
        summary_struct(i).folder = pre_crack_files(ind).folder;
    else
        summary_struct(i).desc = 'force file';
        summary_struct(i).metadata = pecan_test_metadata(...
            I_sort_force(i)-...
            (n_pecan_pre_crack+...
            n_pecan_post_crack+...
            n_pecan_uncracked+...
            n_pecan_diseased));
        summary_struct(i).id = pecan_test_id(...
            I_sort_force(i)-...
            (n_pecan_pre_crack+...
            n_pecan_post_crack+...
            n_pecan_uncracked+...
            n_pecan_diseased));
        
        % calculate index
        ind = I_sort_force(i)-n_pecan_pre_crack-n_pecan_post_crack-...
            n_pecan_uncracked-n_pecan_diseased;
        
        % set paths to structure
        summary_struct(i).filename = force_files(ind).name;
        summary_struct(i).folder = force_files(ind).folder;
    end
end
textprogressbar('terminated');

%% Identify good data in structure

% two valid orderings for data
valid_order_1 = {'pre crack image','force file','post crack image','post crack image'};
valid_order_2 = {'pre crack image','force file','uncracked'};

% find matches to thee two valid orderings
for i = 1:numel(summary_struct)
    % find matches with first valid ordering
    if (i+3)<=numel(summary_struct)
        if isequal({summary_struct(i:(i+3)).desc},valid_order_1) && ...
                (i+3)<=numel(summary_struct)
            for j = 0:3
                summary_struct(i+j).isValid = 1;
            end
        end
    end
    
    % find matches with second valid ordering
    if(i+2)<=numel(summary_struct)
        if isequal({summary_struct(i:(i+2)).desc},valid_order_2)
            for j = 0:2
                summary_struct(i+j).isValid = 1;
            end
        end
    end
end

% set all other elements in summary structure equal to zero
for i = 1:numel(summary_struct)
    if isempty(summary_struct(i).isValid)
        summary_struct(i).isValid = 0;
    end
end

% verify summary structure
ver_summary_struct = summary_struct;

% clean up summary struct
ver_summary_struct(~[ver_summary_struct(:).isValid]) = [];

%% Verify that structure ordering looks good

for i = 1:numel(ver_summary_struct)
    if i == 1
        if ~strcmp(ver_summary_struct(i).desc,'pre crack image')
            disp('first entry should be a pre crack image')
            disp(i)
            break
        end
    else
        if strcmp(ver_summary_struct(i).desc,'force file')
            if ~strcmp(ver_summary_struct(i-1).desc,'pre crack image')
                disp('a force file must always follow a pre crack image')
                disp(i)
                break
            elseif ~((strcmp(ver_summary_struct(i+1).desc,'post crack image'))...
                    ||(strcmp(ver_summary_struct(i+1).desc,'diseased'))||...
                    (strcmp(ver_summary_struct(i+1).desc,'uncracked')))
                disp(['either a post crack image, a diseased image,'...
                    'or an uncracked image must follow a force file'])
                disp(i)
                break
            end
        elseif strcmp(ver_summary_struct(i).desc,'post crack image')
            if (~strcmp(ver_summary_struct(i-1).desc,'force file'))...
                    &&(~strcmp(ver_summary_struct(i-1).desc,'post crack image'))
                disp(['a post crack image must always follow a '...
                    'force file unless it''s the second post crack'...
                    'image in a row'])
                disp(i)
                break
            elseif (strcmp(ver_summary_struct(i-1).desc,'post crack image'))...
                    &&(strcmp(ver_summary_struct(i-1).desc,'pre crack image'))
                disp(['if the previous image is a post crack image,'...
                    'the following image must be a post crack image'])
                break
            end
        elseif strcmp(ver_summary_struct(i).desc,'diseased')
            if (~strcmp(ver_summary_struct(i-1).desc,'force file'))
                disp('a force file must precede a diseased image')
                disp(i)
                break
            elseif (~strcmp(ver_summary_struct(i+1).desc,'pre crack image'))
                disp('a pre crack image must follow a diseased image')
                disp(i)
                break
            end
        elseif strcmp(ver_summary_struct(i).desc,'pre crack image')
            if ~((strcmp(ver_summary_struct(i-1).desc,'post crack image'))...
                    ||(strcmp(ver_summary_struct(i-1).desc,'diseased'))||...
                    (strcmp(ver_summary_struct(i-1).desc,'uncracked')))
                disp(['either a post crack image, a diseased image,'...
                    'or an uncracked image must precede a pre crack image'])
                disp(i)
                break
            elseif (~strcmp(ver_summary_struct(i+1).desc,'force file'))
                disp('a force file must follow a pre crack image')
                disp(i)
                break
            end
        else
            if (~strcmp(ver_summary_struct(i-1).desc,'force file'))
                disp('a force file must precede an uncracked image')
                disp(i)
                break
            elseif (~strcmp(ver_summary_struct(i+1).desc,'pre crack image'))
                disp('a pre crack image must follow an uncracked image')
                disp(i)
                break
            end
        end     
    end
end

% success
disp('Your code has successfully passed the test!! Congragulations')

%% Create new directories

%{

% get current time vector
time_current = clock;

% pecan data master
pec_data_fold = 'C:\Users\Dani\Documents\Pecan-Project-Image-Processing\Pecan_Data_Master';

% new folder name
new_folder_main = strcat('Pecan_Data-',...
    sprintf('%04d',time_current(1)),...
    sprintf('%02d',time_current(2)),...
    sprintf('%02d',time_current(3)),...
    '_',...
    sprintf('%02d',time_current(4)),...
    sprintf('%02d',time_current(5)),...
    sprintf('%02d',round(time_current(6))));

% make directory
mkdir(fullfile(pec_data_fold,new_folder_main));

% folder structure
force_folder = 'Pecan_Data-Force_Files';
image_folder = 'Pecan_Data-Image_Files';
image_subfolders = {'Pre_Crack','Post_Crack','Uncracked','Diseased'};

% make folder structure
% image folder
mkdir(fullfile(pec_data_fold,new_folder_main,image_folder));
% force folder
mkdir(fullfile(pec_data_fold,new_folder_main,force_folder));

% image subfolders
for i = 1:4
    mkdir(fullfile(pec_data_fold,new_folder_main,image_folder,image_subfolders{i}));
end

% trash data location
trash_loc = 'D:\Pecan-Project-Trash-Data';

% new folder name
folder_main_trash = strcat('Pecan_Data_TRASH-',...
    sprintf('%04d',time_current(1)),...
    sprintf('%02d',time_current(2)),...
    sprintf('%02d',time_current(3)),...
    '_',...
    sprintf('%02d',time_current(4)),...
    sprintf('%02d',time_current(5)),...
    sprintf('%02d',round(time_current(6))));

% make directory
mkdir(fullfile(trash_loc,folder_main_trash));

% make folder structure
% image folder
mkdir(fullfile(trash_loc,folder_main_trash,image_folder));
% force folder
mkdir(fullfile(trash_loc,folder_main_trash,force_folder));

% image subfolders
for i = 1:4
    mkdir(fullfile(trash_loc,folder_main_trash,image_folder,image_subfolders{i}));
end

%}


%{
%% Move/Delete files 
textprogressbar(pad('moving and deleting files:',60));
for i = 1:numel(summary_struct)
    textprogressbar(100*(i/numel(summary_struct)));
    if strcmp(summary_struct(i).desc,'pre crack image')
        if ~(exist(fullfile(summary_struct(i).folder,summary_struct(i).filename),'file') && ...
            exist(fullfile(pec_data_fold,new_folder_main,image_folder,'Pre_Crack'),'file') && ...
            exist(fullfile(trash_loc,folder_main_trash,image_folder,'Pre_Crack'),'file'))
            
            % check for existence of relevant files
            error('some files do not exist')
            
        end
            
        
        % copy to main folder if applicable
        if summary_struct(i).isValid
            copyfile(...
                fullfile(summary_struct(i).folder,summary_struct(i).filename),...
                fullfile(pec_data_fold,new_folder_main,image_folder,'Pre_Crack'));
        end
        
        % copy to trash folder regardless
        copyfile(...
            fullfile(summary_struct(i).folder,summary_struct(i).filename),...
            fullfile(trash_loc,folder_main_trash,image_folder,'Pre_Crack'));
        
        % delete object
        delete(fullfile(summary_struct(i).folder,summary_struct(i).filename));
    elseif strcmp(summary_struct(i).desc,'post crack image')
        if ~(exist(fullfile(summary_struct(i).folder,summary_struct(i).filename),'file') && ...
            exist(fullfile(pec_data_fold,new_folder_main,image_folder,'Post_Crack'),'file') && ...
            exist(fullfile(trash_loc,folder_main_trash,image_folder,'Post_Crack'),'file'))
            
            % check for existence of relevant files
            error('some files do not exist')
            
        end
        % copy to main folder if applicable
        if summary_struct(i).isValid
            copyfile(...
                fullfile(summary_struct(i).folder,summary_struct(i).filename),...
                fullfile(pec_data_fold,new_folder_main,image_folder,'Post_Crack'));
        end
        
        % copy to trash folder regardless
        copyfile(...
            fullfile(summary_struct(i).folder,summary_struct(i).filename),...
            fullfile(trash_loc,folder_main_trash,image_folder,'Post_Crack'));
        
        % delete object
        delete(fullfile(summary_struct(i).folder,summary_struct(i).filename));
    elseif strcmp(summary_struct(i).desc,'uncracked')
        if ~(exist(fullfile(summary_struct(i).folder,summary_struct(i).filename),'file') && ...
            exist(fullfile(pec_data_fold,new_folder_main,image_folder,'Uncracked'),'file') && ...
            exist(fullfile(trash_loc,folder_main_trash,image_folder,'Uncracked'),'file'))
            
            % check for existence of relevant files
            error('some files do not exist')
            
        end
        % copy to main folder if applicable
        if summary_struct(i).isValid
            copyfile(...
                fullfile(summary_struct(i).folder,summary_struct(i).filename),...
                fullfile(pec_data_fold,new_folder_main,image_folder,'Uncracked'));
        end
        
        % copy to trash folder regardless
        copyfile(...
            fullfile(summary_struct(i).folder,summary_struct(i).filename),...
            fullfile(trash_loc,folder_main_trash,image_folder,'Uncracked'));
        
        % delete object
        delete(fullfile(summary_struct(i).folder,summary_struct(i).filename));
    elseif strcmp(summary_struct(i).desc,'diseased')
        if ~(exist(fullfile(summary_struct(i).folder,summary_struct(i).filename),'file') && ...
            exist(fullfile(trash_loc,folder_main_trash,image_folder,'Diseased'),'file'))
            
            % check for existence of relevant files
            error('some files do not exist')
            
        end
        % copy to trash folder regardless
        copyfile(...
            fullfile(summary_struct(i).folder,summary_struct(i).filename),...
            fullfile(trash_loc,folder_main_trash,image_folder,'Diseased'));
        
        % delete object
        delete(fullfile(summary_struct(i).folder,summary_struct(i).filename));
    else
        if ~(exist(fullfile(summary_struct(i).folder,summary_struct(i).filename),'file') && ...
            exist(fullfile(pec_data_fold,new_folder_main,force_folder),'file') && ...
            exist(fullfile(trash_loc,folder_main_trash,force_folder),'file'))
            
            % check for existence of relevant files
            error('some files do not exist')
            
        end
        % copy to main folder if applicable
        if summary_struct(i).isValid
            copyfile(...
                fullfile(summary_struct(i).folder,summary_struct(i).filename),...
                fullfile(pec_data_fold,new_folder_main,force_folder));
        end
        
        % copy to trash folder regardless
        copyfile(...
            fullfile(summary_struct(i).folder,summary_struct(i).filename),...
            fullfile(trash_loc,folder_main_trash,force_folder));
        
        % delete object
        delete(fullfile(summary_struct(i).folder,summary_struct(i).filename));
    end
end
textprogressbar('terminated');

textprogressbar(pad('deleting files:',60));
for i = 1:numel(force_folders)
    textprogressbar(100*(i/numel(force_folders)));
    delete(fullfile(force_folders(i).folder,force_folders(i).name));
end       
textprogressbar('terminated');
%}

%% MATLAB Closeout Tasks

save('C:\Users\Dani\Documents\Pecan-Project-Image-Processing\Pecan_Data_Master\DataStatus','ver_summary_struct');

clearvars -except ver_summary_struct
workspace;  % Make sure the workspace panel is showing.