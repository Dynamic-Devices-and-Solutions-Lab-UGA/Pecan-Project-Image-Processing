function figurePath = figurePath

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Set path for figure output
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

figurePath = fullfile(DefaultLoc,'Documents\Pecan-Project-Image-Processing\FigureGeneration\Thesis_Plots');