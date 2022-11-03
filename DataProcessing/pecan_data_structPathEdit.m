%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Edit path for files in pecan_data_struct
%
% Author: Dani Agramonte
% Last Updated: 09.26.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialize MATLAB

clear variables; % Clear variables
workspace;  % Make sure the workspace panel is showing.
commandwindow();

%% Post-Initialize MATLAB

% set path of where data is located
data_path = fullfile(projectPath,'DataProcessing\Pecan_Data_Master\Pecan_Data-20220526_145147\Pecan_Data-Image_Files');

% load in info about valid files
load(fullfile(projectPath,'DataProcessing\Pecan_Data_Master\pecan_data_structOld.mat'),'pecan_data_struct')

%% Update Folder

for i = 1:numel(pecan_data_struct)
    for j = 1:numel(pecan_data_struct(i).test)
        % get parts of path for pre crack test
        pathparts = strsplit(pecan_data_struct(i).test(j).pre_crack_data.file,'\');

        % set new path
        pecan_data_struct(i).test(j).pre_crack_data.file = fullfile(data_path,'Pre_Crack',pathparts{end});

        if strcmp(pecan_data_struct(i).test(j).result,'Unsuccessful Crack')
        elseif strcmp(pecan_data_struct(i).test(j).result,'Successful Crack')
            for k = 1:2
                % get parts of path for post crack crack test
                pathparts = strsplit(pecan_data_struct(i).test(j).post_crack_data.half(k).file,'\');

                % set new path
                pecan_data_struct(i).test(j).post_crack_data.half(k).file = fullfile(data_path,'Post_Crack',pathparts{end});
            end
        end
    end
end

%% MATLAB Closeout Tasks

save(fullfile(projectPath,'DataProcessing\Pecan_Data_Master\pecan_data_struct.mat'),'pecan_data_struct');

% clearvars -except ver_summary_struct
workspace;  % Make sure the workspace panel is showing.