%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Load in force file and video files
%
% Author: Dani Agramonte
% Last Updated: 05.12.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialize MATLAB
clear; % Clear variables
clc;  % Clear command window.
workspace;  % Make sure the workspace panel is showing.

%% Post-Initialization of MATLAB

% adds TDMS function to MATLAB path
addpath(genpath('C:\Users\Dani\Documents\Pecan-Project-Image-Processing\tdms'))
addpath(genpath('C:\Users\Dani\Documents\Pecan-Project-Image-Processing\Windows_API'))

% set path of where data is located
data_path = 'C:\Users\Dani\Documents\Pecan-Project-Image-Processing\Pecan_Video_Data_Master';

%% Data input

% get video files
video_files = dir(fullfile(data_path,'Videos','*.mp4*'));

% get force files
force_files = dir(fullfile(data_path,'Force','*.tdms'));

% experiment to look at
i = 2;

% video input file
V = VideoReader(fullfile(video_files(i).folder,video_files(i).name));

% forcepath
force_path = fullfile(force_files(i).folder,force_files(i).name);

% 
h = figure;

WindowAPI(h,'TopMost')

for frame_index = 1:400

    video_frame = read(V,frame_index);

    [force,max_force] = force_accel_processing(force_path);

    % define time domain over which action occurs
    sample_rate = 10^4; %10kHz
    t = 1000*(0:(1/sample_rate):(size(force,1)/sample_rate)); % time in ms

    subplot(2,1,1);
    imshow(imlocalbrighten(video_frame))

    subplot(2,1,2); 
    plot(t(1:(2*frame_index)),force(1:(2*frame_index)))
    
    hold on

    plot(t(frame_index),force(frame_index),'r*')
    
    hold off
    
    xlim([0 t(2*frame_index)])
    xlabel('Time [ms]')
    ylabel('Force [g]')
    drawnow
end

% remove unnecessary paths for path cleaning
rmpath('C:\Users\Dani\Documents\Pecan-Project-Image-Processing\tdms');
