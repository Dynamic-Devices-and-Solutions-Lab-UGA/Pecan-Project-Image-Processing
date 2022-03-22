function calib = pecan_calibration(val,varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Calibrate length or area of pecan to mm or mm^2, depending on user
% inputs.
%
% Author: Dani Agramonte
% Last Updated: 03.16.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% parse inputs into function
[x, param] = parseinputs(val,varargin);

% Change the current folder to the folder of this m-file.
if(~isdeployed)
  cd(fileparts(which(mfilename)));
end

% calibration constant
calib_constant = 9.4;

% calibrate values
if param == true
    calib = x./calib_constant;
else
    calib = x./(calib_constant^2);
end


end % pecan_calibration

%-----------END MAIN FUNCTION-----------%

function [x, param] = parseinputs(x,varargin)
% PARSEINPUTS put x in the correct form, and parse user parameters

% CHECK x
% Make sure x is Nx1
if size(x, 1) == 1
    x = x'; 
end
if size(x, 2) ~= 1
    error('pecan_calibration:InvalidDimension', ...
        'Input matrix must be one dimensional')
end

% Determine if we are calibrating to area or distance
if ~isempty(varargin{1}) && strncmpi(varargin{1},'distance',...
        length(varargin{1}))
    param = true;
elseif ~isempty(varargin{1}) && strncmpi(varargin{1},'area',...
        length(varargin{1}))
    param = false;
else
    param = true;
end

end % parseinputs