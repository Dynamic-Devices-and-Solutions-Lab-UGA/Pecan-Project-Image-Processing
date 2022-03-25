function [perc,query_length,query_width] = PHE(pre_crack_path,...
    post_crack_path,varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Estimate area of pecan half by comparing with a reference pecan. Scale
% the shell of the reference to the query pecan and then scale the area of
% the meat by this same factor. After doing so, compare this area with the
% area of the query pecan half
%
% Inputs
% ---------------
% pre_crack_path       : path of image before the crack. Can be relative or
%                        absolute
% post_crack_path      : path of image after the crack. Can be relative or
%                        absolute
% varargin             : optional inputs (see explanation)
% 
% Optional Inputs
% ---------------
% pre_cracked_bw       : overlay precracked query image onto 
%                        precracked reference. takes true or false values 
% post_cracked_bw      : overlay postcracked image. takes true or false
%                        values. false by default.
% bounding_box         : turn bounding box around all images on. takes true
%                        or false values. false by default
% method               : method by which ideal post cracked area is
%                        calculated. The possible values for this are
%                        'direct_area' or 'bounding_box'. 'bounding_box' by
%                        default.
%
% Outputs
% ---------------
% perc                 : percentage of pecan which is a double value from
%                        0-100. Values greater than 100 will result in a
%                        warning and values less than 0 will result in an
%                        error
% length               : length of query pecan in mm. Values less than 0 
%                        will result in an error.
% width                : width of query pecan in mm. Values less than 0 
%                        will result in an error.
%
% Author: Dani Agramonte
% Last Updated: 03.22.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[pre_crack_path,post_crack_path,params] = parseinputs(pre_crack_path,...
    post_crack_path,varargin{:});

% get reference values for area, length, and width
[ref_pre_crack_area,ref_length,ref_width,bounding_box_ref,bw_pre_crack_ref] = pecan_property_get(...
    'Pecan Test Images/20220323_133233.jpg');
[ref_post_crack_area,~,~,~,bw_post_crack_ref] = pecan_property_get(...
    'Pecan Test Images/20220323_133327.jpg');

% Try to get pecan data from two image paths
try
    try
        % try to use absolute path
        [query_pre_crack_area,query_length,query_width,bounding_box_query,bw_pre_crack_query] = pecan_property_get(...
            pre_crack_path);
    catch
        currentFolder = pwd;
        Full_File_Path = fullfile(currentFolder,pre_crack_path);
        [query_pre_crack_area,query_length,query_width,bounding_box_query,bw_pre_crack_query] = pecan_property_get(...
            Full_File_Path);
    end
catch ME
    rethrow(ME)
end

try
    try
        % try to use absolute path
        [query_post_crack_area,~,~,~,bw_post_crack_query] = pecan_property_get(...
            post_crack_path);
    catch
        currentFolder = pwd;
        Full_File_Path = fullfile(currentFolder,post_crack_path);
        [query_post_crack_area,~,~,~,bw_post_crack_query] = pecan_property_get(...
            Full_File_Path);
    end
catch ME
    rethrow(ME)
end

switch params.method
    case 0
        perc = 100*query_post_crack_area/((query_length/ref_length)*...
            (query_width/ref_width)*ref_post_crack_area);
    case 1
        perc = 100*query_post_crack_area/((ref_post_crack_area/...
            ref_pre_crack_area)*query_pre_crack_area);
end

if params.pre_cracked_bw
    figure
    imshow(bw_pre_crack_query)
    showMaskAsOverlay(0.5,bw_pre_crack_ref,'r')
    
    if params.bounding_box
        hold on
        rectangle('Position',bounding_box_ref,'EdgeColor','b')
        rectangle('Position',bounding_box_query,'EdgeColor','b')
    end
end

if params.post_cracked_bw
    figure
    imshow(bw_post_crack_query)
    showMaskAsOverlay(0.5,bw_post_crack_ref,'r')
end

%-----------END MAIN FUNCTION-----------%

function [pre_crack_path,post_crack_path,params] = parseinputs(pre_crack_path,...
    post_crack_path,varargin)
% PARSEINPUTS: ensure that paths are strings, and parse user parameters

% Check if paths are strings or not
if ~(ischar(pre_crack_path)&&ischar(post_crack_path))
    error('input paths must be strings!')
end

% Parse property/value pairs
if rem(length(varargin), 2) ~= 0
    error('PHE_m2:InvalidInputArguments', ...
        'Additional arguments must take the form of Property/Value pairs')
end

% Cell array of valid property names
valid_properties = {'pre_cracked_bw', 'post_cracked_bw', 'bounding_box','method'};

% Set default values
params.pre_cracked_bw = 0;
params.post_cracked_bw = 0;
params.bounding_box = 0;
params.method = 0;

while ~isempty(varargin)
    % Pop pair off varargin
    property = varargin{1};
    value = varargin{2};
    varargin(1:2) = [];
    
    % If the property has been supplied in a shortened form, lengthen it
    iProperty = find(strncmpi(property, valid_properties, length(property)));
    if isempty(iProperty)
        error('PHE_m2:UnknownProperty', 'Unknown Property');
    elseif length(iProperty) > 1
        error('PHE_m2:AmbiguousProperty', ...
            'Supplied shortened property name is ambiguous');
    end
    
    % Expand property to its full name
    property = valid_properties{iProperty};
        
    % Check supplied property value
    switch property
        case 'pre_cracked_bw'
            switch value
                case 'true'
                    params.pre_cracked_bw = 1;
                case 'false'
                    params.pre_cracked_bw = 0;
                otherwise
                    error('PHE_m2:InvalidValue',...
                        'pre_cracked_bw must be either ''true'' or ''false''');
            end
        case 'post_cracked_bw'
            switch value
                case 'true'
                    params.post_cracked_bw = 1;
                case 'false'
                    params.post_cracked_bw = 0;
                otherwise
                    error('PHE_m2:InvalidValue',...
                        'post_cracked_bw must be either ''true'' or ''false''');
            end
        case 'bounding_box'
            switch value
                case 'true'
                    params.bounding_box = 1;
                case 'false'
                    params.bounding_box = 0;
                otherwise
                    error('PHE_m2:InvalidValue',...
                        'bounding_box must be either ''true'' or ''false''');
            end
        case 'method'
            switch value
                case 'bounding_box'
                    params.method = 0;
                case 'direct_area'
                    params.method = 1;
                otherwise
                    error('PHE_m2:InvalidValue',...
                        'method must either be bounding_box or direct_area');
            end
    end % switch property
end % while

end % parseinputs

end