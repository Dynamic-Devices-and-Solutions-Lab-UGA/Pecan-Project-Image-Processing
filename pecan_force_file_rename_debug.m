%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% A short script to rename files with incorrectly formatted dates and
% incorrectly formatted metadata values per ASCII standards. Only needs to
% be executed once.
%
% Author: Dani Agramonte
% Last Updated: 04.14.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% get force files
force_files = dir(fullfile(fullfile(pwd,...
    'PecanDataMaster','PecanData-converted'), '*.tdms'));

% number of force files
n_force_files = length(force_files);

for i = 1:n_force_files
    % create new name based off of the old naming convention
    newname = append(force_files(i).name(5:8),...
        force_files(i).name(1:4),force_files(i).name(1:end));
    newname(9:16) = [];
    
    % insert 0 to make name comply with ASCII standards
    if (i>=23)&&(i<=35)
        newname = insertAfter(newname,'20220413_194252-Angle.30-Height.76.2','0');
    end
    
    % get new and old files
    fullfile_new = fullfile(force_files(i).folder,newname);
    fullfile_old = fullfile(force_files(i).folder,force_files(i).name);
    
    % rename files
    movefile(fullfile_old,fullfile_new);
    
    % delete old file
    delete(fullfile_old);
end