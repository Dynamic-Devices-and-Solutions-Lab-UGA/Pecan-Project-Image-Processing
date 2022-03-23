function [perc,query_length,query_width] = PHE_m2(pre_crack_path,...
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
%                        values
% bounding_box         : turn bounding box around all images on. takes true
%                        or false values
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

%{
% Check if paths are strings or not
if ~(ischar(pre_crack_path)&&ischar(post_crack_path))
    error('input paths must be strings!')
end
%}

% get reference values for area, length, and width
[~,ref_length,ref_width,~] = pecan_property_get(...
    'Pecan Test Images/20220315_132317.jpg');
[ref_post_crack_area,~,~,~] = pecan_property_get(...
    'Pecan Test Images/20220315_132337.jpg');

% Try to get pecan data from two image paths
try
    try
        % try to use absolute path
        [~,query_length,query_width,~] = pecan_property_get(...
            pre_crack_path);
    catch
        currentFolder = pwd;
        Full_File_Path = fullfile(currentFolder,pre_crack_path);
        [~,query_length,query_width,~] = pecan_property_get(...
            Full_File_Path);
    end
catch ME
    rethrow(ME)
end

try
    try
        % try to use absolute path
        [query_post_crack_area,~,~,~] = pecan_property_get(...
            post_crack_path);
    catch
        currentFolder = pwd;
        Full_File_Path = fullfile(currentFolder,post_crack_path);
        [query_post_crack_area,~,~,~] = pecan_property_get(...
            Full_File_Path);
    end
catch ME
    rethrow(ME)
end

perc = 100*query_post_crack_area/((query_length/ref_length)*...
    (query_width/ref_width)*ref_post_crack_area);

%-----------END MAIN FUNCTION-----------%

function [x, params] = parseinputs(x, params, varargin)
% PARSEINPUTS put x in the correct form, and parse user parameters

% CHECK x
% Make sure x is 2xN where N > 3
if size(x, 2) == 2
    x = x'; 
end
if size(x, 1) ~= 2
    error('fitellipse:InvalidDimension', ...
        'Input matrix must be two dimensional')
end
if size(x, 2) < 6
    error('fitellipse:InsufficientPoints', ...
        'At least 6 points required to compute fit')
end


% Determine whether we are solving for geometric (nonlinear) or algebraic
% (linear) distance
if ~isempty(varargin) && strncmpi(varargin{1}, 'linear', length(varargin{1}))
    params.fNonlinear = false;
    varargin(1)       = [];
else
    params.fNonlinear = true;
end

% Parse property/value pairs
if rem(length(varargin), 2) ~= 0
    error('fitellipse:InvalidInputArguments', ...
        'Additional arguments must take the form of Property/Value pairs')
end

% Cell array of valid property names
properties = {'pre_cracked_bw', 'post_cracked_bw', 'bounding_box'};

while length(varargin) ~= 0
    % Pop pair off varargin
    property      = varargin{1};
    value         = varargin{2};
    varargin(1:2) = [];
    
    % If the property has been supplied in a shortened form, lengthen it
    iProperty = find(strncmpi(property, properties, length(property)));
    if isempty(iProperty)
        error('fitellipse:UnknownProperty', 'Unknown Property');
    elseif length(iProperty) > 1
        error('fitellipse:AmbiguousProperty', ...
            'Supplied shortened property name is ambiguous');
    end
    
    % Expand property to its full name
    property = properties{iProperty};
    
    % Check for irrelevant property
    if ~params.fNonlinear && ismember(property, {'maxits', 'tol'})
        warning('fitellipse:IrrelevantProperty', ...
            'Supplied property has no effect on linear estimate, ignoring');
        continue
    end
        
    % Check supplied property value
    switch property
        case 'maxits'
            if ~isnumeric(value) || value <= 0
                error('fitcircle:InvalidMaxits', ...
                    'maxits must be an integer greater than 0')
            end
            params.maxits = value;
        case 'tol'
            if ~isnumeric(value) || value <= 0
                error('fitcircle:InvalidTol', ...
                    'tol must be a positive real number')
            end
            params.tol = value;
        case 'constraint'
            switch lower(value)
                case 'bookstein'
                    params.constraint = 'bookstein';
                case 'trace'
                    params.constraint = 'trace';
                otherwise
                    error('fitellipse:InvalidConstraint', ...
                        'Invalid constraint specified')
            end
    end % switch property
end % while

end % parseinputs

end