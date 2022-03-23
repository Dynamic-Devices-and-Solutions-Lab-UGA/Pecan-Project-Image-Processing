function [force,max_force] = force_processing(path)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Force processing function to get number of bounces and bounce time from
% force data
%
% Author: Dani Agramonte
% Last Updated: 03.21.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;  % Clear command window.
workspace;  % Make sure the workspace panel is showing.

% construct full path
currentFolder = pwd;
FullFileName = fullfile(currentFolder,path);

TDMS_Struct = TDMS_getStruct(FullFileName);
names = fieldnames(TDMS_Struct);
force = getfield(TDMS_Struct,names{2},'Dev2_1_ai1','data');

% error handling if force is empty
if isempty(force)
    force = zeros(5000,1);
    warning('%s has no force data and should be deleted',...
        TDMS_Struct.Props.name)
end

max_force = max(force);


    

