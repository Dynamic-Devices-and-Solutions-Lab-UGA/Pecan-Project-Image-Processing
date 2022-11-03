%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% This script chnanges data locations from old folders (Athens DDSL
% computer) to new folders (Dani's personal computer)
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
load(fullfile(projectPath,'DataProcessing\Pecan_Data_Master\DataStatusOld.mat'),'ver_summary_struct')

%% Update Folder

for i = 1:numel(ver_summary_struct)
    if strcmp(ver_summary_struct(i).desc,'pre crack image')
        ver_summary_struct(i).folder = fullfile(data_path,'Pre_Crack');
    elseif strcmp(ver_summary_struct(i).desc,'uncracked')
        ver_summary_struct(i).folder = fullfile(data_path,'Uncracked');
    elseif strcmp(ver_summary_struct(i).desc,'post crack image')
        ver_summary_struct(i).folder = fullfile(data_path,'Post_Crack');
    end
end

%% MATLAB Closeout Tasks

save(fullfile(projectPath,'DataProcessing\Pecan_Data_Master\DataStatus.mat'),'ver_summary_struct');

clearvars -except ver_summary_struct
workspace;  % Make sure the workspace panel is showing.