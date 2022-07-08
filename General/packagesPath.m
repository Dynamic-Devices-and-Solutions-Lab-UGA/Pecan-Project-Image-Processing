function path = packagesPath

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Set path for packages
%
% Author: Dani Agramonte
% Last Updated: 07.08.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% add functionality for dealing with systems with OneDrive on it
if isempty(getenv('OneDrive'))
    DefaultLoc = [getenv('HOMEDRIVE'),getenv('HOMEPATH')];
else
    DefaultLoc = getenv('OneDrive');
end

path = fullfile(DefaultLoc,'Documents\MATLAB-Packages');