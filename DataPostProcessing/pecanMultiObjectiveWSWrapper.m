%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Wrapper for pecanMultiObjectiveWeightStudy for parallelizing
%
% Author: Dani Agramonte
% Last Updated: 07.09.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% main loop
parfor i = 1:8
    pecanMultiObjectiveWeightStudy(i)
end