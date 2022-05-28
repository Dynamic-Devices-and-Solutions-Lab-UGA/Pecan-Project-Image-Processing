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
    im_dir = varargin{2};
end

% set locations for destination
prc_loc = fullfile(im_dir,'Pre_Crack');
poc_loc = fullfile(im_dir,'Post_Crack');
dd_loc = fullfile(im_dir,'Diseased');
uc_loc = fullfile(im_dir,'Uncracked');

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
debug_flag = 0;

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
g.RowHeight = {'5x','1x'};
g.ColumnWidth = {'5x'};

% set grid background colors
g.BackgroundColor = bkd;


%% create image

% load in image
im_pec = imread(pecan_image_path,'ReductionLevel',30);

% rotate image if it has to be 
if size(im_pec,1)>size(im_pec,2)
    im_pec = imrotate(im_pec,90);
end

% create uiimage object as a child of grid object
im = uiimage(g,'ImageSource',im_pec);

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
b1.Text = '1 - Pre Crack';
b1.Layout.Row = 1;
b1.Layout.Column = 1;

b2 = uibutton(g2);
b2.Text = '2 - Post Crack';
b2.Layout.Row = 1;
b2.Layout.Column = 2;

b3 = uibutton(g2);
b3.Text = '3 - Diseased';
b3.Layout.Row = 1;
b3.Layout.Column = 3;

b4 = uibutton(g2);
b4.Text = '4 - Uncracked';
b4.Layout.Row = 1;
b4.Layout.Column = 4;

b5 = uibutton(g2);
b5.Text = '5 - Delete';
b5.Layout.Row = 1;
b5.Layout.Column = 5;

% specify callback functions for each 
set(b1,'ButtonPushedFcn',{@pb_call1,debug_flag,prc_loc,fh})
set(b2,'ButtonPushedFcn',{@pb_call2,debug_flag,poc_loc,fh})
set(b3,'ButtonPushedFcn',{@pb_call3,debug_flag,dd_loc,fh})
set(b4,'ButtonPushedFcn',{@pb_call4,debug_flag,uc_loc,fh})
set(b5,'ButtonPushedFcn',{@pb_call5,debug_flag,fh})


% specify callback function for the figure
set(fh,'KeyPressFcn',{@pb_kpf,debug_flag,prc_loc,poc_loc,dd_loc,uc_loc,pecan_image_path});

% wait until button is pressed
uiwait(fh);

%% actions of buttons

% pre crack
function pb_call1(varargin)
    if ~varargin{3}
        % resume function
        uiresume(varargin{1})
        disp('Pre Crack')
        % move file
        movefile(varargin{8},varargin{4})
    end
end

% post crack
function pb_call2(varargin)
    if ~varargin{3}
        % resume function
        uiresume(varargin{1})
        disp('Post Crack')
        % move file
        movefile(varargin{8},varargin{5})
    end
end

% diseased
function pb_call3(varargin)
    if ~varargin{3}
        % resume function
        uiresume(varargin{1})
        disp('Diseased')
        % move file
        movefile(varargin{8},varargin{6})
    end
end

% uncracked
function pb_call4(varargin)
    if ~varargin{3}
        % resume function
        uiresume(varargin{1})
        disp('Uncracked')
        % move file
        movefile(varargin{8},varargin{7})
    end
end

% delete
function pb_call5(varargin)
    if ~varargin{3}
        % resume function
        uiresume(varargin{1})
        disp('delete')
        % delete 
        delete(varargin{8})
    end
end

% function which associates a key press with buttons
function pb_kpf(varargin)
    if varargin{2}.Character == '1'
        pb_call1(varargin{:})
    elseif varargin{2}.Character == '2'
        pb_call2(varargin{:})
    elseif varargin{2}.Character == '3'
        pb_call3(varargin{:})
    elseif varargin{2}.Character == '4'
        pb_call4(varargin{:})
    elseif varargin{2}.Character == '5'
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