load('DataStatus.mat')
pre_crack_file = fullfile(ver_summary_struct(18).folder,ver_summary_struct(18).filename);
post_crack_file = fullfile(ver_summary_struct(20).folder,ver_summary_struct(20).filename);

[pre_crack_area,pre_crack_pec_length,pre_crack_pec_width,~,pre_crack_bw,pre_crack_ecc,pre_crack_ext] = ...
                pecan_property_get(pre_crack_file);

[post_crack_area,~,~,post_crack_bounding_box,post_crack_bw,~,~]= pecan_property_get(post_crack_file);

s = regionprops(pre_crack_bw,'ConvexArea','BoundingBox','Eccentricity','Extent','MaxFeretProperties','MinFeretProperties');

centerx = mean(s.MaxFeretCoordinates(:,1));
centery = mean(s.MaxFeretCoordinates(:,2));

B = bwboundaries(pre_crack_bw);
coords = B{:};

xcoords = coords(:,2);
ycoords = coords(:,1);

xcoords_r = zeros(size(xcoords));
ycoords_r = zeros(size(ycoords));

xcoordsFeretMax = s.MaxFeretCoordinates(:,1);
ycoordsFeretMax = s.MaxFeretCoordinates(:,2);
xcoordsFeretMax_r = zeros(2,1);
ycoordsFeretMax_r = zeros(2,1);

xcoordsFeretMin = s.MinFeretCoordinates(:,1);
ycoordsFeretMin = s.MinFeretCoordinates(:,2);
xcoordsFeretMin_r = zeros(2,1);
ycoordsFeretMin_r = zeros(2,1);

Angle = s.MaxFeretAngle;

% Angle = 90+s.MinFeretAngle;

for i = 1:size(xcoords,1)
    xcoords_r(i) = ((xcoords(i)-centerx)*cosd(Angle)-((centery-ycoords(i))*sind(Angle)))+centerx;
    ycoords_r(i) = centery-((centery-ycoords(i))*cosd(Angle)+((xcoords(i)-centerx)*sind(Angle)));
end

for i = 1:2
    xcoordsFeretMax_r(i) = ((xcoordsFeretMax(i)-centerx)*cosd(Angle)-((centery-ycoordsFeretMax(i))*sind(Angle)))+centerx;
    ycoordsFeretMax_r(i) = centery-((centery-ycoordsFeretMax(i))*cosd(Angle)+((xcoordsFeretMax(i)-centerx)*sind(Angle)));

    xcoordsFeretMin_r(i) = ((xcoordsFeretMin(i)-centerx)*cosd(Angle)-((centery-ycoordsFeretMin(i))*sind(Angle)))+centerx;
    ycoordsFeretMin_r(i) = centery-((centery-ycoordsFeretMin(i))*cosd(Angle)+((xcoordsFeretMin(i)-centerx)*sind(Angle)));
end

%plot(xcoords,ycoords)
hold on
plot(xcoords_r,ycoords_r)

%plot(xcoordsFeret,ycoordsFeret)
plot(xcoordsFeretMax_r,ycoordsFeretMax_r)
plot(xcoordsFeretMin_r,ycoordsFeretMin_r)

% find nearest intersection with curve
intersection1 = dsearchn([xcoords_r,ycoords_r],[xcoordsFeretMax_r(1);ycoordsFeretMax_r(1)]');
intersection2 = dsearchn([xcoords_r,ycoords_r],[xcoordsFeretMax_r(2);ycoordsFeretMax_r(2)]');

plot(xcoords_r(intersection1),ycoords_r(intersection1),'ro')
plot(xcoords_r(intersection2),ycoords_r(intersection2),'ro')

f2 = (ycoords_r-ycoordsFeretMax_r(1)).^2+ycoordsFeretMax_r(1);
f3 = f2(intersection2:intersection1);


% get ellipsoidal estimates
a = s.BoundingBox(3)/2;
b = s.BoundingBox(4)/2;

shell = (10*9.4*0.15);

est_height = 0.7*b;

%{

theta = 0;
r1 = a;
r2 = b;
xc = centerx;
yc = centery;

% compute points corresponding to axis-oriented ellipse
t = linspace(0, 2*pi, 200);
xt = r1 * cos(t) + xc;
yt = r2 * sin(t) + yc;
% aply rotation by angle theta
cot = cos(theta); sit = sin(theta);
x = xt * cot - yt * sit;
y = xt * sit + yt * cot;
% draw the curve
plot(x, y, '-');

%f2 = (ycoords_r-ycoordsFeret_r(1)).^2+ycoordsFeret_r(1);
%f3 = f2(intersection2:intersection1);
%}

vol_precrack = (pi/2)*trapz(flip(xcoords_r(intersection2:intersection1)),f3)/(9.4^3);

% plot(xcoords_r(intersection2:intersection1),f2(intersection2:intersection1))

% vol2 = s.ConvexArea*s.BoundingBox(4)/(9.4^3);

vol_post_crack = post_crack_area*est_height/(9.4);

ratio = vol_post_crack/vol_precrack;

ratio2 = post_crack_area/pre_crack_area;