%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% initializes project folder
%
% Author: Dani Agramonte
% Last Updated: 06.03.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% checks OS - only Windows is currently supported due to pathing issues
if ~ispc
    error('Currently only windows is supported')
else
    fprintf('\nProject Check: Using Windows OS...Complete\n')
end

% gets all current project dependencies
packageListRequired = pecanProjectDependencies();

% creates path where we expect our packages to go
username = getenv('USERNAME');
pathPackages = fullfile('C:\Users',username,'Documents\MATLAB Packages');

% get current packages
currentPackages = dir(pathPackages);

% remove '.' and '..' from package list
currentPackages = currentPackages(~ismember({currentPackages.name},{'.','..'}));

% get current packages names
currentPackagesNames = {currentPackages(:).name};

% ensure that each required package exists
for i = 1:numel(packageListRequired)
    if isempty(find(strcmp(currentPackagesNames, char(packageListRequired{i})),1))
        error('Cannot proceed: %s package required',packageListRequired{i})
    else
        fprintf('Project Check: %s package included...Complete\n',packageListRequired{i})
    end
end

% open file
fileID = fopen(fullfile(projectPath,'pecanProjectEnvVars.txt'),'r+');

fprintf(fileID,'INITIALIZATIONSTATUS = TRUE');

fclose(fileID);

