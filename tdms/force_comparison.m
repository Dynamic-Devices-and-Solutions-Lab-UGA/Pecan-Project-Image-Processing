%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Compare different force curves for different trials
%
% Author: Dani Agramonte
% Last Updated: 03.21.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

current_loc = pwd;
complete_dir = fullfile(pwd,'Acceleration_and_Force_Data');
files = dir(fullfile(complete_dir,'*.tdms'));
iter = size(files,1);

plot_m = zeros(5000,iter);

for i = 1:iter
    plot_m(:,i) = force_processing(fullfile('Acceleration_and_Force_Data',files(i).name));
    plot(plot_m(:,i))
    hold on
end

