%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Create geometric model for impactor design
%
% Author: Dani Agramonte
% Last Updated: 06.02.2022
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% semi-major and semi-minor axes
a = 0.940;
b = 0.522;

% parametric variable
t = linspace(0,2*pi,10000);

% ellipse
x = a*cos(t);
y = b*sin(t);

% slope for line
%m = 

plot(x,y)
yline(0.75)
yline(-0.75)
