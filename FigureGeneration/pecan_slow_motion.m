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

Fontsize = 12;
% set default interpreter
set(groot,'defaultAxesTickLabelInterpreter','latex');  
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

% metadata
metadata = parsemetadata(force_files(i).name);


for frame_index = 1:frame_final

    % read each frame of video
    video_frame = read(V,frame_index);

    % top subplot
    subplot(2,1,1);
    % plot image brightened
    imshow(imadjust(video_frame,[0 0.5],[0 1],0.5))

    % bottom subplot
    subplot(2,1,2);
    
    % plot force data from t = 0 to 2*t_point, where t_point is the time of
    % the data point we're plotting
    plot(t(1:(2*frame_index)),force((1+shift(i)):(2*frame_index+shift(i))))
    
    xlim([0 t(2*frame_index)])
    xlabel('Time [ms]','FontSize',Fontsize)
    ylabel('Force [g]','FontSize',Fontsize)
    title('Force vs. Time during pecan impact','FontSize',Fontsize)

    % set background to white
    set(gcf,'color','white')
    
    % Create axes object
    ax1 = gca;
    
    % set axis fontsize
    set(ax1,'FontSize',Fontsize);
    
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

    % export 
    filename = sprintf('PecanImpactSlowMotion-Material.%s-Mass.%3.1f-Height.%3.2f-Angle.%2.0f-%d.pdf',metadata.Material,metadata.Mass,metadata.Height,metadata.Angle,frame_index);
    foldername = sprintf('PecanImpactSlowMotion-Material.%s-Mass.%3.1f-Height.%3.2f-Angle.%2.0f',metadata.Material,metadata.Mass,metadata.Height,metadata.Angle);

    if ~isfolder(fullfile(projectPath,'FigureGeneration','Thesis_Plots',foldername))
        mkdir(fullfile(projectPath,'FigureGeneration','Thesis_Plots',foldername))
    end

    export_fig(gcf,fullfile(projectPath,'FigureGeneration','Thesis_Plots',foldername,filename));
    
    % pause 
    pause(pause_time)
end

%% Closeout MATLAB

clear; % Clear variables
clc;  % Clear command window.
workspace;  % Make sure the workspace panel is showing.


% parse metadata function

function [metadata] = parsemetadata(val)
% parsemetadata: get metadata from 

% Cell array of metadata property names
properties = {'Angle', 'Height', 'Mass','Material'};

% use '-' delimeters to split metadata
val_split = strsplit(char(val),'-');

% initialize metadata structure
metadata = [];

for i = 1:length(val_split)
    for j = 1:4
        if sum(strcmpi(strsplit(char(val_split(i)),'.'),properties(j)))>0
            if ismember('Material',properties(j))
                % pop off property for Material
                temp = char(val_split(i));
                metadata.(properties{j}) = ...
                    temp((length(char(properties(j)))+2):end);
            else
                % pop off property for all other properties and convert to
                % number
                temp = char(val_split(i));
                metadata.(properties{j}) = str2double(temp(...
                    (length(char(properties(j)))+2):end));
            end
        end
    end
end

end % parsemetadata