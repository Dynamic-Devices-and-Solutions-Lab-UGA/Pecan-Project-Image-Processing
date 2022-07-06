function packageList = pecanProjectDependencies()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% get all project dependencies
%
% Author: Dani Agramonte
% Last Updated: 06.03.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% main

projectFiles =  dir(fullfile(projectPath,'*.m'));

for i = numel(projectFiles):-1:1
    projectFilePaths(i) = {fullfile(projectFiles(i).folder,projectFiles(i).name)};
end

% get dependencies 
fList = matlab.codetools.requiredFilesAndProducts(projectFilePaths);

% initialize package list variable
packageList = cell(numel(fList),1);

for i = 1:numel(fList)
    fileparts = split(fList(i),'\');
    if ~strcmp(fileparts(5),'Pecan-Project-Image-Processing')
        packageList(i) = {fileparts(6)};
    end
end

packageList = unique([packageList{:}]);