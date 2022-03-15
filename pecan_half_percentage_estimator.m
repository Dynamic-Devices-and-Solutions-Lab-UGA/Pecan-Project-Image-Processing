I = imread('20220314_182645_2.jpg');
X = imbinarize(I);
imshow(X(:,:,2))
bw = ~X;
bw = bw(:,:,2);

s = regionprops(bw, 'Orientation', 'MajorAxisLength', ...
'MinorAxisLength', 'Eccentricity', 'Centroid');

imshow(bw)
hold on
phi = linspace(0,2*pi,50);
cosphi = cos(phi);
sinphi = sin(phi);
for k = 1:length(s)
    % gather centroid of ellipse
    xbar = s(k).Centroid(1);
    ybar = s(k).Centroid(2);
    
    % Skip ellipse if it is smaller than a threshold
    if s(k).MajorAxisLength<100
        continue
    end
    
    % gather major and minor axes of the ellipse
    a = s(k).MajorAxisLength/2;
    b = s(k).MinorAxisLength/2;
    
    % gather rotation of ellipse
    theta = pi*s(k).Orientation/180;
    
    % rotation matrix
    R = [ cos(theta)   sin(theta)
    -sin(theta)   cos(theta)];
    xy = [a*cosphi; b*sinphi];
    xy = R*xy;
    x = xy(1,:) + xbar;
    y = xy(2,:) + ybar;
    plot(x,y,'r','LineWidth',2);
end
hold off



