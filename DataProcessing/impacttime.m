%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Calculate length of
%
% Author: Dani Agramonte
% Last Updated: 05.29.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialize MATLAB
clear; % Clear variables
clc;  % Clear command window.
workspace;  % Make sure the workspace panel is showing.

%% Post-Initialization of MATLAB

% set path of where data is located
data_path = fullfile(projectPath,'DataProcessing/Pecan_Video_Data_Master');

%% Variable Definitions

% experiment to look at
i = 6;

% shift for each experiment - tune individually
shift = [40;10;0;0;0;0];

% final frame
frame_final = 200;

% pause time after iteration is done
pause_time = 1/10;

%% Data input

% get video files
video_files = dir(fullfile(data_path,'Videos','*.mp4*'));

% get force files
force_files = dir(fullfile(data_path,'Force','*.tdms'));

% video input file
V = VideoReader(fullfile(video_files(i).folder,video_files(i).name));

% forcepath
force_path = fullfile(force_files(i).folder,force_files(i).name);

%% plot

% read force out from TDMS file
[force,~] = force_accel_processing(force_path);

% define time domain over which action occurs
sample_rate = 10^4; %10kHz
% t = 1000*(0:(1/sample_rate):(size(force,1)/sample_rate)); % time in ms
t = linspace(0,(size(force,1)/sample_rate),750);

Fontsize = 12;
% set default interpreter
set(groot,'defaultAxesTickLabelInterpreter','latex');  
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

plot(t,force)