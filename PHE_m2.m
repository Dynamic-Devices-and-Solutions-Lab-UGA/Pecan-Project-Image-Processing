%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Estimate area of a pecan by fitting an ellipse to the boundary of the
% pecan and comparing the areas
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

[half_area_est,bw] = convex_area_estimator('Pecan Test Images/20220315_132356.jpg');
bound = edge(bw);
[x,y] = find(bound);

%{
ellipse_t = fit_ellipse(x,y);
 
% Fit an ellipse using the Bookstein constraint
[zb, ab, bb, alphab] = fitellipse([x,y], 'linear');

% Find the least squares geometric estimate       
[zg, ag, bg, alphag] = fitellipse([x,y]);

imshow(~bw)
hold on
% Plot the results
plotellipse(zb, ab, bb, alphab, 'b--')
plotellipse(zg, ag, bg, alphag, 'k')

est_area_1 = pi*ellipse_t.a*ellipse_t.b;
est_area_2 = pi*ab*bb;
est_area_3 = pi*ag*bg;

perc_1 = 100*half_area_est\est_area_1
perc_2 = 100*half_area_est\est_area_2
perc_3 = 100*half_area_est\est_area_3
%}
s = regionprops(bw, 'Orientation', 'MajorAxisLength', ...
    'MinorAxisLength', 'Eccentricity', 'Centroid');
imshow(bw)
hold on

phi = linspace(0,2*pi,50);
cosphi = cos(phi);
sinphi = sin(phi);

for k = 1:length(s)
    xbar = s(k).Centroid(1);
    ybar = s(k).Centroid(2);

    a = s(k).MajorAxisLength/2;
    b = s(k).MinorAxisLength/2;

    theta = pi*s(k).Orientation/180;
    R = [ cos(theta)   sin(theta)
         -sin(theta)   cos(theta)];

    xy = [a*cosphi; b*sinphi];
    xy = R*xy;

    x = xy(1,:) + xbar;
    y = xy(2,:) + ybar;

    plot(x,y,'r','LineWidth',2);
end
hold off


