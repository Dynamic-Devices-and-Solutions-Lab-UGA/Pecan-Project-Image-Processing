function [force,max_force] = force_accel_processing(path)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Force processing function to get number of bounces and bounce time from
% force data
%
% Author: Dani Agramonte
% Last Updated: 04.12.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% construct full path
currentFolder = pwd;
FullFileName = fullfile(currentFolder,path);

% try to get the structure with a relative path, then an absolute path
try
    TDMS_Struct = TDMS_getStruct(FullFileName);
catch
    TDMS_Struct = TDMS_getStruct(path);
end

names = fieldnames(TDMS_Struct);
force = force_accel_calibration(getfield(TDMS_Struct,names{2},...
    'Dev2_1_ai0','data'),'force');

% select only first 75 ms of data given sampling rate of 10kHz
force = force(1:750);

% error handling if force is empty
if isempty(force)
    force = zeros(5000,1);
    warning('%s has no force data and should be deleted',...
        TDMS_Struct.Props.name)
end

max_force = max(force);