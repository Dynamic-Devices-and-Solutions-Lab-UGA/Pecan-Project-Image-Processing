%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Load in force file and video files and play them in sync
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
% adds Windows API function to MATLAB path
addpath(genpath('C:\Users\Dani\Documents\Pecan-Project-Image-Processing\Windows_API'))
% adds MIMT toolbox
addpath(genpath('C:\Users\Dani\Documents\Pecan-Project-Image-Processing\MIMT'));

% set path of where data is located
data_path = 'C:\Users\Dani\Documents\Pecan-Project-Image-Processing\Pecan_Video_Data_Master';

%% Variable Definitions

% experiment to look at
i = 2;

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

%% Create animation

% create figure/figure handle
h = figure(1);

% constrain 
WindowAPI(h,'TopMost')

% read force out from TDMS file
[force,~] = force_accel_processing(force_path);

% define time domain over which action occurs
sample_rate = 10^4; %10kHz
t = 1000*(0:(1/sample_rate):(size(force,1)/sample_rate)); % time in ms

for frame_index = 1:frame_final

    % read each frame of video
    video_frame = read(V,frame_index);
    
    % if it's the first iteration, define chart data
    if frame_index == 1        
        xlim([0 t(2*frame_index)])
        xlabel('Time [ms]')
        ylabel('Force [g]')
        title('Force vs. Time during pecan impact')
    end

    % top subplot
    subplot(2,1,1);
    % plot image
    imshow(imlocalbrighten(video_frame))

    % bottom subplot
    subplot(2,1,2);
    
    % plot force data from t = 0 to 2*t_point, where t_point is the time of
    % the data point we're plotting
    plot(t(1:(2*frame_index)),force((1+shift(i)):(2*frame_index+shift(i))))
    
    % set aspect ratio of plot box
    pbaspect([size(video_frame,2),size(video_frame,1) 1])
    
    % don't erase existing plots
    hold on

    % plot point
    plot(t(frame_index),force(frame_index+shift(i)),'r*')
    
    % enable next iteration to erase old plots
    hold off
    
    % draw now to render every plot element at end of loop
    drawnow
    
    % pause 
    pause(pause_time)
end

%% Closeout MATLAB

% remove unnecessary paths for path cleaning
rmpath(genpath('C:\Users\Dani\Documents\Pecan-Project-Image-Processing\tdms'));
rmpath(genpath('C:\Users\Dani\Documents\Pecan-Project-Image-Processing\Windows_API'))
rmpath(genpath('C:\Users\Dani\Documents\Pecan-Project-Image-Processing\MIMT'));

clear; % Clear variables
clc;  % Clear command window.
workspace;  % Make sure the workspace panel is showing.