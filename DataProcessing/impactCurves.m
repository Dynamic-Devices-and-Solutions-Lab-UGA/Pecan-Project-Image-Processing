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


% final frame
frame_final = 200;

% pause time after iteration is done
pause_time = 1/10;

%% Data input

% get video files
video_files = dir(fullfile(data_path,'Videos','*.mp4*'));

% get force files
force_files = dir(fullfile(data_path,'Force','*.tdms'));

%% Create animation

% create figure/figure handle
h = figure(1);

% constrain 
WindowAPI(h,'TopMost')

Fontsize = 26;
% set default interpreter
set(groot,'defaultAxesTickLabelInterpreter','latex');  
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');


for i = 1:6

    % forcepath
    force_path = fullfile(force_files(i).folder,force_files(i).name);
    
    % read force out from TDMS file
    [force,~] = force_accel_processing(force_path);

    % define time domain over which action occurs
    sample_rate = 10^4; %10kHz
    t = 1000*(0:(1/sample_rate):(size(force,1)/sample_rate)); % time in ms

    % read each frame of video
    % video_frame = read(V,frame_index);

    % top subplot
    %subplot(2,1,1);
    % plot image brightened
    %imshow(imadjust(video_frame,[0 0.5],[0 1],0.5))

    % bottom subplot
    %subplot(2,1,2);
    
    % plot force data from t = 0 to 2*t_point, where t_point is the time of
    % the data point we're plotting
    plot(t(1:300),force(1:300))
    
    xlim([0 t(300)])
    xlabel('Time [ms]','FontSize',Fontsize)
    ylabel('Force [g]','FontSize',Fontsize)
    % title('Force vs. Time during pecan impact','FontSize',Fontsize)

    % set background to white
    set(gcf,'color','white')
    
    % Create axes object
    ax1 = gca;
    
    % set axis fontsize
    set(ax1,'FontSize',Fontsize);
    
    % set aspect ratio of plot box
    % pbaspect([size(video_frame,2),size(video_frame,1) 1])
    
    % don't erase existing plots
    hold on
    
    % draw now to render every plot element at end of loop
    drawnow
end

% use Cynthia Brewer's research to make a colormap for the surface fit
ax1.ColorOrder = flip(linspecer(7,'red'));
set(gcf,'Position',[80 80 1600 800])

% create colorbar
c = colorbar;
colormap(linspecer('red'));
caxis([0 2])

ylabel(c,'Height [m]','FontSize',Fontsize,'Rotation',270,'Interpreter','latex')
c.Label.Position(1) = 5;
set(c,'TickLabelInterpreter','latex')

x1 = 10;
x2 = 10.75;
x3 = 12.5;
x4 = 23;

l1 = xline(x1,'--');
l2 = xline(x2,'--');
l3 = xline(x3,'--');
l4 = xline(x4,'--');

ylim([-50 1100])

% get current ylimits
ylims = ylim;

color2 = linspecer(4,'gray');

% patch([x1 x2 x2 x1],[ylims(1) ylims(1) ylims(2) ylims(2)],color2(2,:),'FaceAlpha',0.2,'LineStyle','none')
% patch([x2 x3 x3 x2],[ylims(1) ylims(1) ylims(2) ylims(2)],color2(3,:),'FaceAlpha',0.2,'LineStyle','none')
% patch([x3 x4 x4 x3],[ylims(1) ylims(1) ylims(2) ylims(2)],color2(4,:),'FaceAlpha',0.2,'LineStyle','none')

% export 
filename = sprintf('PecanImpactTimeHistory.pdf');
% foldername = sprintf('PecanImpactSlowMotion-Material.%s-Mass.%3.1f-Height.%3.2f-Angle.%2.0f',metadata.Material,metadata.Mass,metadata.Height,metadata.Angle);
export_fig(gcf,fullfile(projectPath,'FigureGeneration','Thesis_Plots',filename));

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