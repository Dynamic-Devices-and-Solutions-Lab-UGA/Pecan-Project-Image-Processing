function [area,pec_length,pec_width,bounding_box,bw,ecc,ext] = pecan_property_get(path,...
    varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Image processing script to get properties from an uncalibrated pecan
% image
%
% Author: Dani Agramonte
% Last Updated: 04.11.22
%
% Inputs
% ---------------
% path                 : path of image. must be an absolute path
% varargin             : optional inputs (see explanation)
% 
% Optional Inputs
% ---------------
% debug                : go into debug mode. show binary image. takes true
%                        or false values. false by default
% bounding_box         : turn bounding box around all images on. takes true
%                        or false values. false by default
% delay_figure         : delay creation of figure. takes true or false values
%                        false by default
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% parse inputs with auxiliary function
[path,params] = parseinputs(path,varargin{:});

% read image from file
I_raw = imread(path);

%%%% -- Note -- %%%%
% deal with matlab not properly handling the orientation property

% get image info
I_info = imfinfo(path);

% orient image properly
if isfield(I_info,'Orientation')
    
    % get orientation property
    EXIF_Orientation = I_info.Orientation;
    
    %%%%%%%%%% ------------ %%%%%%%%%%%%
    % note: only non mirror exif
    % orientation values are currently 
    % supported
    %%%%%%%%%% ------------ %%%%%%%%%%%%
    
    switch EXIF_Orientation
        case 1
            % do nothing
        case 6
            % rotate 90 deg cw
            I_raw = rot90(I_raw,-1);
        case 3
            % rotate 180 deg ccw
            I_raw = rot90(I_raw,2);
        case 8
            % rotate 90 deg ccw
            I_raw = rot90(I_raw,1);
        otherwise
            error('Orientation Property Value NOT Recognized')
    end
end

% get image dimensions
im_dims = size(I_raw);

if (im_dims(1) == 4032)&&(im_dims(2) == 1960)
    % if image dims are flipped, rotate ccw
    I_raw = rot90(I_raw);
elseif ~((im_dims(1) == 1960)&&(im_dims(2) == 4032))
    % dimensions aren't compatible with what is expected from the camera
    error('pecan_property_get:image is not correctly size');
end

% crop image
imStep1 = imcrop(I_raw,[1500 150 1500 950]);

% convert to grayscale
imStep2 = rgb2gray(imStep1);

% binarize image and invert to create mask
imStep3 = ~imbinarize(imStep2,'adaptive','Sensitivity',0.7);

% perform light opening operation to remove noise
imStep4 = imopen(imStep3,strel('Disk',1));

% perform closing operation
imStep5 = imclose(imStep4,strel('Disk',7));

% fill in remaining holes in image
imStep6 = imfill(imStep5,8,'holes');

% filter out every object except for the largest one
bw = bwareafilt(imStep6,1);

% find the area of the projected pecan
s = regionprops(bw,'ConvexArea','BoundingBox','Eccentricity','Extent');
area = pecan_calibration(s(1).ConvexArea,'area');


% find length and width of pecan
dims = pecan_calibration(s(1).BoundingBox,'distance');

% find extent
ext = s.Extent;

% find eccentricity
ecc = s.Eccentricity;

% remove shift in box
dims = dims(3:4);
pec_length = max(dims);
pec_width = min(dims);

% bounding box info in terms of pixels
bounding_box = s(1).BoundingBox;

if params.debug
    % create figure and figure handle
    h = figure;
    
    % get current axis
    ax = gca;
    
    if params.delay_figure
        set(h, 'Visible', 'off');
        drawnow;
    end
    
    imshow(imStep1,'Parent',ax)
    showMaskAsOverlay(0.15,bw,'r')
    
    if params.bounding_box
        hold on
        rectangle('Position',bounding_box,'EdgeColor','b')
    end
end


%-----------END MAIN FUNCTION-----------%

function [path,params] = parseinputs(path,varargin)
% PARSEINPUTS: ensure that paths are strings, and parse user parameters

% Check if paths are strings or not
if ~(ischar(path))
    error('Input paths must be strings!')
end

% Parse property/value pairs
if rem(length(varargin), 2) ~= 0
    error('pecan_property_get:InvalidInputArguments', ...
        'Additional arguments must take the form of Property/Value pairs')
end

% Cell array of valid property names
valid_properties = {'debug','bounding_box','delay_figure'};

% Set default values
params.debug = 0;
params.bounding_box = 0;
params.delay_figure = 0;

while ~isempty(varargin)
    % Pop pair off varargin
    property = varargin{1};
    value = varargin{2};
    varargin(1:2) = [];
    
    % If the property has been supplied in a shortened form, lengthen it
    iProperty = find(strncmpi(property, valid_properties, length(property)));
    if isempty(iProperty)
        error('pecan_property_get:UnknownProperty', 'Unknown Property');
    elseif length(iProperty) > 1
        error('pecan_property_get:AmbiguousProperty', ...
            'Supplied shortened property name is ambiguous');
    end
    
    % Expand property to its full name
    property = valid_properties{iProperty};
        
    % Check supplied property value
    switch property
        case 'debug'
            switch value
                case 'true'
                    params.debug = 1;
                case 'false'
                    params.debug = 0;
                otherwise
                    error('pecan_property_get:InvalidValue',...
                        'pre_cracked_bw must be either ''true'' or ''false''');
            end
        case 'bounding_box'
            switch value
                case 'true'
                    params.bounding_box = 1;
                case 'false'
                    params.bounding_box = 0;
                otherwise
                    error('pecan_property_get:InvalidValue',...
                        'bounding_box must be either ''true'' or ''false''');
            end
        case 'delay_figure'
            switch value
                case 'true'
                    params.delay_figure = 1;
                case 'false'
                    params.delay_figure = 0;
                otherwise
                    error('pecan_property_get:InvalidValue',...
                        'delay_figure must be either ''true'' or ''false''');
            end
    end % switch property
end % while

end % parseinputs

end