function [] = gui_test(pecan_image_path)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Personal - Testing
% 
% Simple GUI test script
%
% MATLAB Central Link: https://www.mathworks.com/matlabcentral/answers/1450-gui-for-keyboard-pressed-representing-the-push-button#answer_2123
%
% Author: Oleg Komarov
% Last Updated: 05.26.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% figure parameters

% use built in Java method to get screensize
jScreenSize = java.awt.Toolkit.getDefaultToolkit.getScreenSize;

% get physical window size in pixels
screen_height = jScreenSize.getHeight;
screen_width = jScreenSize.getWidth;

% desired size of figure in pixels
desired_height = 750;
desired_width = 1500;

% set background color
bkd = 'white';

% calculate offset from edge
left_offset = screen_width/2-(screen_width-desired_width)/2;
bottom_offset = screen_height/2-(screen_height-desired_height)/2;

%% initialize figure

% initialize uifigure
fh = uifigure;

% [left bottom width height]
fh.Position = [left_offset bottom_offset desired_width desired_height];

% set background color of background
fh.Color = bkd;

% constrain figure to lie on top
WindowAPI(fh,'TopMost')

%% create grid layout from figure

% create grid layout as a child of figure
g = uigridlayout(fh);

% set row and column heights
g.RowHeight = {'20x','4x'};
g.ColumnWidth = {'1x'};

% set grid background colors
g.BackgroundColor = bkd;


%% create image

% create uiimage object as a child of grid object
im = uiimage(g);

% set uiimage object source
im.ImageSource = pecan_image_path;

% set image so that image doesn't get cropped
im.ScaleMethod = 'fit';

% specify location of image on grid
im.Layout.Row = 1;
im.Layout.Column = 1;

%% create panel

% create uipanel figure
p = uipanel(g);

% specify panel title
p.Title = 'User Actions';

% specify panel title position
p.TitlePosition = 'centertop';

% set background color of panel
p.BackgroundColor = bkd;

% specify lcocation of panel on grid layout
p.Layout.Row = 2;
p.Layout.Column = 1;

% specify panel font size
p.FontSize = 12;


%% create grid layout on uipanel

% creat uigridlayout as as a child of uipanel
g2 = uigridlayout(p);

% set background color of grid layout
g2.BackgroundColor = bkd;

% set row and column heights
g2.RowHeight = {'1x'};
g2.ColumnWidth = {'1x','1x','1x','1x','1x'};

%% buttons

% create 5 buttons as a children of the uigridlayout in the uipanel
b1 = uibutton(g2);
b1.Text = 'Button 1';
b1.Layout.Row = 1;
b1.Layout.Column = 1;

b2 = uibutton(g2);
b2.Text = 'Button 2';
b2.Layout.Row = 1;
b2.Layout.Column = 2;

b3 = uibutton(g2);
b3.Text = 'Button 3';
b3.Layout.Row = 1;
b3.Layout.Column = 3;

b4 = uibutton(g2);
b4.Text = 'Button 4';
b4.Layout.Row = 1;
b4.Layout.Column = 4;

b5 = uibutton(g2);
b5.Text = 'Button 5';
b5.Layout.Row = 1;
b5.Layout.Column = 5;

% specify callback functions for each 
set(b1,'ButtonPushedFcn',@pb_call1)
set(b2,'ButtonPushedFcn',@pb_call2)
set(b3,'ButtonPushedFcn',@pb_call3)
set(b4,'ButtonPushedFcn',@pb_call4)
set(b5,'ButtonPushedFcn',@pb_call5)


set(fh,'KeyPressFcn',@pb_kpf);


function pb_call1(varargin)
%S = varargin{3};  % Get the structure.
disp('do the thing')

function pb_call2(varargin)
disp('do the second thing')

function pb_call3(varargin)
disp('do the third thing')

function pb_call4(varargin)
disp('do the fourth thing')

function pb_call5(varargin)
disp('do the fifth thing')

% Do same action as button when pressed 'p'
function pb_kpf(varargin)
if varargin{1,2}.Character == '2'
    pb_call2(varargin{:})
elseif varargin{1,2}.Character == '1'
    pb_call1(varargin{:})
elseif varargin{1,2}.Character == '3'
    pb_call3(varargin{:})
elseif varargin{1,2}.Character == '4'
    pb_call4(varargin{:})
elseif varargin{1,2}.Character == '5'
    pb_call5(varargin{:})
end

function varargout = demoimgs
    pth = fileparts(which('cameraman.tif'));
    D = dir(pth);
    C = {'.tif';'.jp';'.png';'.bmp'};
    idx = false(size(D));
    for ii = 1:length(C)
        idx = idx | (arrayfun(@(x) any(strfind(x.name,C{ii})),D));
    end
    D = D(idx);
    for ii = 1:numel(D)
        fprintf('%s\n',D(ii).name)
    end
    if nargout, varargout{1}=pth; end