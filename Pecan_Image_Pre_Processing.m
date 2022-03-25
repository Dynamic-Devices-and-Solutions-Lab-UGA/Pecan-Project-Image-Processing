%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Pre processing of images in pecan dataset
%
% Author: Dani Agramonte
% Last Updated: 03.25.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Make folders if they don't currently exist
try
    mkdir Pecan_Data_03.24.22_Pre_Processed
    mkdir ./Pecan_Data_03.24.22_Pre_Processed/Pre_Crack
    mkdir ./Pecan_Data_03.24.22_Pre_Processed/Post_Crack
catch ME
end

% Get pre crack files
Pre_Crack_Files = dir(fullfile(fullfile(pwd,'Pecan_Data_03.24.22/Pre_Crack'), '*.jpg'));

for i = 1:length(Pre_Crack_Files)
    [~,~,~,~,bw] = pecan_property_get(fullfile(...
        'Pecan_Data_03.24.22/Pre_Crack',Pre_Crack_Files(i).name));
    imwrite(bw,fullfile(pwd,...
        'Pecan_Data_03.24.22_Pre_Processed/Pre_Crack',...
        sprintf('Pre_Crack_Data_%d.tiff',i)));
end

% Get post crack files
Post_Crack_Files = dir(fullfile(fullfile(pwd,...
    'Pecan_Data_03.24.22/Post_Crack'), '*.jpg'));

for i = 1:length(Post_Crack_Files)
    [~,~,~,~,bw] = pecan_property_get(fullfile(...
        'Pecan_Data_03.24.22/Post_Crack',Post_Crack_Files(i).name));
    imwrite(bw,fullfile(pwd,...
        'Pecan_Data_03.24.22_Pre_Processed/Post_Crack',sprintf(...
        'Post_Crack_Data_%d.tiff',i)));
end