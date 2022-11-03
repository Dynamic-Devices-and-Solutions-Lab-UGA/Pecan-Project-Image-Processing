%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Test out optical frame flow methods
%
% Author: Dani Agramonte
% Last Updated: 10.24.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialize MATLAB
clear; % Clear variables
clc;  % Clear command window.
workspace;  % Make sure the workspace panel is showing.

%% Post-Initialization of MATLAB

% set path of where data is located
data_path = fullfile(projectPath,'DataProcessing/Pecan_Video_Data_Master');

%% Script Parameters

% video we want to look at
vidInd = 6;

%% Data input

% get video files
video_files = dir(fullfile(data_path,'Videos','*.mp4*'));

% video input file
vidReader = VideoReader(fullfile(video_files(vidInd).folder,video_files(vidInd).name),'CurrentTime',0.11);

%% Optical Flow

opticFlow = opticalFlowHS;

h = figure;
movegui(h);
hViewPanel = uipanel(h,'Position',[0 0 1 1],'Title','Plot of Optical Flow Vectors');
hPlot = axes(hViewPanel);

while hasFrame(vidReader)
    frameRGB = readFrame(vidReader);
    frameGray = im2gray(frameRGB);  
    flow = estimateFlow(opticFlow,frameGray);
    imshow(frameRGB)
    hold on
    plot(flow,'DecimationFactor',[5 5],'ScaleFactor',2000,'Parent',hPlot);
    hold off
    pause(10^-3)
end
