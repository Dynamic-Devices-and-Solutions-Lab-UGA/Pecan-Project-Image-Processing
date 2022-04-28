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
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% parse inputs with auxiliary function
[path,params] = parseinputs(path,varargin{:});

% read image from file
I = imread(path);

% get image dimensions
im_dims = size(I);

if (im_dims(1) == 1960)&&(im_dims(2) == 4032)
    % you're good!
elseif (im_dims(2) == 1960)&&(im_dims(1) == 4032)
    % reshuffle dimensions to their correct values
    I = permute(I,[2 1 3]);
else
    % dimensions aren't compatible with what is expected from the camera
    error('pecan_property_get:image is not correctly size');
end

% crop image
I = imcrop(I,[1500 150 1500 950]);


% initially binarize image
X = imbinarize(I);

% read green channel
bw = ~X(:,:,2);

% create a morphological structural element
SE  = strel('Disk',3,4);

% close the image with the previously generated morphological structural
% element
bw = imclose(bw, SE);

% fill any remaining holes in the image
bw = imfill(bw,'holes');

% filter out every object except for the largest one
bw = bwareafilt(bw,1);

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
    figure
    imshow(I)
    showMaskAsOverlay(0.5,bw,'r')
    
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
valid_properties = {'debug','bounding_box'};

% Set default values
params.debug = 0;
params.bounding_box = 0;

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
    end % switch property
end % while

end % parseinputs

end