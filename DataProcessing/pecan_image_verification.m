%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% simple script which verifies that pecan_property get is working for the dataset
%
% Author: Dani Agramonte
% Last Updated: 05.28.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% MATLAB initialization
clear; % Clear variables
clc;  % Clear command window.
workspace;  % Make sure the workspace panel is showing.

% set focus to command window
commandwindow();

%% main

% main data path
dataPath = fullfile(projectPath,...
    'Pecan_Data_Master\DataProcessing\Pecan_Data-20220526_145147\Pecan_Data-Image_Files');

% possible states
pecState = {'Pre_Crack','Post_Crack'};

% choose state
state = 2;

% get all filepaths
imPaths = dir(fullfile(dataPath,pecState{state}));

% remove any directories
imPaths([imPaths.isdir]) = [];

%% Prepare command window for testing

% use built in Java method to get screensize
jScreenSize = java.awt.Toolkit.getDefaultToolkit.getScreenSize;

% get physical window size in pixels
screen_height = jScreenSize.getHeight;
screen_width = jScreenSize.getWidth;

% get current command window position
current_pos = CmdWinTool('JPosition');

% set matlab to take up half of screen
CmdWinTool('JPosition',[current_pos(1:2) screen_width/2 screen_height]);

% % make matlab window always on top
% CmdWinTool('top')

% start index
% ind_start = 1500;
ind_start = 80;

try
    for i = ind_start:numel(imPaths)
        % local path
        imLocalPath = fullfile(imPaths(i).folder,imPaths(i).name);

        % run pecan property get in debug mode
        pecan_property_get(imLocalPath,'debug','true','delay_figure','true');
        commandwindow();
        
        % get handle for current figure
        h = gcf;
        
        % set figure size
        WindowAPI(h,'Position',[1100 150 750 750])
        
        drawnow;
        
        % turn visibility back on
        set(h, 'Visible', 'on');
        
        disp(i)

        pause(0.25)

        % close all figures
        close all
    end
catch ME
    
    % run finalization function if we quit mid way through test script
    finalize;
    
    % rethrow error
    rethrow(ME)
end

% if test is successful, finalize matlab
finalize;

function finalize()

% resest command window
CmdWinTool('maximize')

% % toggle the command window's 'on top' status
% CmdWinTool('top')

end