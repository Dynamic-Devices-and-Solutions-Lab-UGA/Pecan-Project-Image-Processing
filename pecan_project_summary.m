%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Summary of all important functions and scripts in project
%
% Author: Dani Agramonte
% Last Updated: 04.28.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%
%% Functions:
% sloc: counts lines of code in a script
% slocDir: counts lines of code in a directory
% showMaskAsOverlay: overlays a mask on an image with a given coloar and
% opacity
% PHE: estimates percentage of pecan half is present
% pecan_property_get: obtains most critical information about a pecan from
% a photo from a Samsung Galaxy S8 front camera
% pecan_calibration: converts dimensions in pixels to mms
% force_accel_processing: gets most critical information about force and
% acceleration time series siganls
% force_accel_calibration: converts from V to g
%
%% Scripts:
% PHE_Calibration_function_create: loads in data from pecan_PHE_calibration
% and fits a poly11 surface to it and saves the fit
% pecan_PHE_calibration: loads in calibration data and calculates all
% important parameters and data
% pecan_method_comparison_plot: plots data comparison from different
% methods
% pecan_method_comparison: applies different pecan half estimation
% techniques to calibration set and saves data
% pecan_force_file_rename_debug: renames a large quantity of force files to
% something consistent with the new naming convention
% pecan_data_struct_create: creates a data structure with all information
% about every test
%
%% Directories:
% Trash_Data: old picture data
% tdms: contains functions which convert .tdms data to a matlab structure
% Pecan_Refence_Images: contains pecan images which serve as reference for
% some of the PHE techniques
% Pecan_Data_Master: contains all testing data
% Pecan_Calibration_Images: contains all calibration images
% Pecan_Calibration_Data: contains all data needed for calibration of the
% calib_surf model. Also contains the calib_surf model itself.