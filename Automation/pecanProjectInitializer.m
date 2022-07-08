%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% initializes project folder
%
% Author: Dani Agramonte
% Last Updated: 06.03.22s
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% add functionality for dealing with systems with OneDrive on it
if isempty(getenv('OneDrive'))
    DefaultLoc = [getenv('HOMEDRIVE'),getenv('HOMEPATH')];
else
    DefaultLoc = getenv('OneDrive');
end

pathMain = fullfile(DefaultLoc,'Documents\Pecan-Project-Image-Processing');

% add all subfolders in project to path
addpath(genpath(pathMain))

% get environmental variable for the status of the setup of the project
if isequal(getenv('PecanInitializationStatus'),'true')
    disp('Project is set up correctly')
else
    disp('Project setup incomplete...')
    % checks OS - only Windows is currently supported due to pathing issues
    if ~ispc
        error('Currently only windows is supported')
    else
        fprintf('\nProject Check: Using Windows OS...Complete\n')
    end
    
    % gets all current project dependencies
    packageListRequired = pecanProjectDependencies();
    
    % get current packages
    currentPackages = dir(packagesPath);
    
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

    % create environmental variable
    system('setx PecanInitializationStatus true')

    disp('Project setup complete.')
end