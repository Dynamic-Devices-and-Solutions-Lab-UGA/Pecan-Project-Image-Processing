function pathMain = projectPath()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Set main path system
%
% Author: Dani Agramonte
% Last Updated: 07.08.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% add functionality for dealing with systems with OneDrive on it
if isempty(genenv('OneDrive'))
    DefaultLoc = [getenv('HOMEDRIVE'),getenv('HOMEPATH')];
else
    DefaultLoc = getenv('OneDrive');
end

pathMain = fullfile(DefaultLoc,'Documents\Pecan-Project-Image-Processing');