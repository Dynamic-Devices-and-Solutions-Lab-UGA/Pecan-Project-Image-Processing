function [force] = force_processing(path)

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
% Change the current folder to the folder of this m-file.
if(~isdeployed)
  cd(fileparts(which(mfilename)));
end

clc;  % Clear command window.
workspace;  % Make sure the workspace panel is showing.

% construct full path
currentFolder = pwd;
FullFileName = fullfile(currentFolder,path);

% TDMS_Struct = TDMS_getStruct('C:\Users\dnagr\OneDrive\Desktop\Agramonte, Dani Enrique\6. DDSL\14. Master''s Research\4. Pecan Project Image Processing\Acceleration_and_Force_Data\pec.id.340-imp.60-hold.60-mass.448.42-converted.tdms')

TDMS_Struct = TDMS_getStruct(FullFileName);
force = TDMS_Struct.unnamedTask_5_.Dev2_1_ai1.data;

