%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Estimate area of pecan half by comparing with what a typical half takes
% up in relation to the entire pecan
%
% Author: Dani Agramonte
% Last Updated: 03.15.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Change the current folder to the folder of this m-file.
if(~isdeployed)
  cd(fileparts(which(mfilename)));
end

clear;
clc;

[est_total,~,~,bw1] = pecan_property_get('Pecan Test Images/20220315_132317.jpg');
[est_half,~,~,bw2] = pecan_property_get('Pecan Test Images/20220315_132337.jpg');
[est_half_broken,~,~,bw3] = pecan_property_get('Pecan Test Images/20220315_132356.jpg');

perc_whole = 100*(est_half/est_total)
perc_broken = 100*(est_half_broken/est_total)
perc_broken_ref = 100*perc_broken/perc_whole