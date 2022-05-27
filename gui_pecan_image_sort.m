function [] = gui_pecan_image_sort(varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% gui script for pecan data
%
% Author: Dani Agramonte
% Last Updated: 05.27.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% input parsing

if nargin==2
    pecan_image_path = varargin{1}; %#ok<NASGU>
    dest_path = varargin{2};
end

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
left_offset = (screen_width-desired_width)/2;
bottom_offset = (screen_height-desired_height)/2;

%% debug mode

% debug flag
debug_flag = 1;

if debug_flag
    pecan_image_path = getRandImage;
end

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
b1.Text = 'Pre Crack';
b1.Layout.Row = 1;
b1.Layout.Column = 1;

b2 = uibutton(g2);
b2.Text = 'Post Crack';
b2.Layout.Row = 1;
b2.Layout.Column = 2;

b3 = uibutton(g2);
b3.Text = 'Uncracked';
b3.Layout.Row = 1;
b3.Layout.Column = 3;

b4 = uibutton(g2);
b4.Text = 'Diseased';
b4.Layout.Row = 1;
b4.Layout.Column = 4;

b5 = uibutton(g2);
b5.Text = 'Delete';
b5.Layout.Row = 1;
b5.Layout.Column = 5;

% specify callback functions for each 
set(b1,'ButtonPushedFcn',{@pb_call1,debug_flag,dest_path})
set(b2,'ButtonPushedFcn',{@pb_call2,debug_flag,dest_path})
set(b3,'ButtonPushedFcn',{@pb_call3,debug_flag,dest_path})
set(b4,'ButtonPushedFcn',{@pb_call4,debug_flag,dest_path})
set(b5,'ButtonPushedFcn',{@pb_call5,debug_flag,dest_path})


% specify callback function for the figure
set(fh,'KeyPressFcn',@pb_kpf);

%% actions of buttons

function pb_call1(varargin)
    if ~varargin{2}
        movefile(current_file_path,varargin{3})
    end
end

function pb_call2(varargin)
    if ~varargin{2}
        movefile(current_file_path,varargin{3})
    end
end

function pb_call3(varargin)
    if ~varargin{2}
        movefile(current_file_path,varargin{3})
    end
end

function pb_call4(varargin)
    if ~varargin{2}
        movefile(current_file_path,varargin{3})
    end
end

function pb_call5(varargin)
    if ~varargin{2}
        movefile(current_file_path,varargin{3})
    end
end

% function which associates a key press with buttons
function pb_kpf(varargin)

    if varargin{1}.Character == '1'
        pb_call1(varargin{:})
    elseif varargin{1}.Character == '2'
        pb_call2(varargin{:})
    elseif varargin{1}.Character == '3'
        pb_call3(varargin{:})
    elseif varargin{1}.Character == '4'
        pb_call4(varargin{:})
    elseif varargin{1}.Character == '5'
        pb_call5(varargin{:})
    end
end

function randPath = getRandImage(imageDir, imageExtensions)
    
    % if imageDir doesn't exist, get it
    if nargin < 1 || isempty(imageDir)
        imageDir = fullfile(toolboxdir('images'), 'imdata');
    end
    
    % ensure directory exists and throw error if not
    assert(exist(imageDir,'dir')==7, 'Directory does not exist.')
    
    % if no image extensions are provided, get some
    if nargin < 2 || isempty(imageExtensions)
        %imageExtensions = {'.tif';'.tiff';'.jpeg';'.jpg';'.png';'.bmp'};
        imageExtensions = {'.jpeg';'.jpg';'.png';'.svg';'.gif'};
    else
        assert(all(startsWith(imageExtensions, '.')), 'All file extensions must start with a period.')
    end
    
    % Get paths to all images files from listed image extensions
    % Ignore images that are greater than a threshold size in bytes
    D = dir(imageDir);
    [~,~,ext] = fileparts({D.name});
    isExtMatch = ismember(lower(ext), lower(imageExtensions));
    byteLimit = 1E7;
    sizeOK = [D.bytes]<byteLimit;
    imageList = D(isExtMatch & sizeOK);
    imagePaths = fullfile({imageList.folder}, {imageList.name});
    
    % get rand index
    ir = randi(numel(imagePaths));
    
    % assign to output
    randPath = fullfile(D(ir).folder,imageList(ir).name);
    
end % getRandImage

end % gui_pecan_image_sort