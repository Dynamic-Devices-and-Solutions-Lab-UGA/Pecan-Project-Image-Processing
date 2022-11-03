%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Calculate Feret properties of pecans
%
% Author: Dani Agramonte
% Last Updated: 10.11.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load in data
load('DataStatus.mat')

% initialize variables
VolEst = [];
Dg = [];
SA = [];
Sph = [];
maxF = [];
minF = [];

%#ok<*AGROW> 

for i = 1:numel(ver_summary_struct)
    if strcmp(ver_summary_struct(i).desc,'pre crack image')
        % get pre crack file path
        pre_crack_file = fullfile(ver_summary_struct(i).folder,ver_summary_struct(i).filename);

        % get binary processed image
        [~,~,~,~,pre_crack_bw,~,~] = pecan_property_get(pre_crack_file);
        
        % get region properties
        s = regionprops(pre_crack_bw,'MaxFeretProperties','MinFeretProperties');

        % calibrate min and max feret diameters
        minFi = pecan_calibration(s.MinFeretDiameter,'distance');
        maxFi = pecan_calibration(s.MaxFeretDiameter,'distance');

        % calculate current vals
        VolEsti = (pi/6)*maxFi*minFi^2;
        Dgi = (maxFi*minFi^2)^(1/3);
        SAi = pi*Dgi^2;
        Sphi = Dgi/maxFi;

        % create matrix
        VolEst = [VolEst;VolEsti];
        Dg = [Dg;Dgi];
        SA = [SA;SAi];
        Sph = [Sph;Sphi];
        maxF = [maxF;maxFi];
        minF = [minF;minFi];
    end
end