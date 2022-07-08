function calib = force_accel_calibration(val,varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Calibrate force or acceleration of input
%
% Author: Dani Agramonte
% Last Updated: 04.11.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% parse inputs into function
[x, param] = parseinputs(val,varargin);

% calibration constants
calib_constant_force = 0.489e-3; % [V/g]
calib_constant_accel = 0.0577e-3; % [V/N]

% calibrate values

if param == true
    calib = x./calib_constant_force;
else
    calib = x./(calib_constant_accel);
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
        'Input matrix must be N-by-1')
end

% Determine if we are calibrating to force or acceleration
if ~isempty(varargin{1}) && strncmpi(varargin{1},'force',...
        length(varargin{1}))
    param = true;
elseif ~isempty(varargin{1}) && strncmpi(varargin{1},'acceleration',...
        length(varargin{1}))
    param = false;
else
end
end