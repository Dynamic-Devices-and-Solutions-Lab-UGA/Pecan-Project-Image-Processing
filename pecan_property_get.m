function [area,length,width,bounding_box,bw] = pecan_property_get(path)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Image processing script to get properties from an uncalibrated pecan
% image
%
% Author: Dani Agramonte
% Last Updated: 03.15.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;  % Clear command window.
workspace;  % Make sure the workspace panel is showing.

% read image from file
I = imread(path);

% crop image
I = imcrop(I,[1480 730 830 570]);

% initially binarize image
X = imbinarize(I);

% read green channel
bw = ~X(:,:,2);

% create a morphological structural element
SE  = strel('Disk',3,4);

% close the image with the previously generated morphological structural
% element
bw = imclose(bw, SE);

% fill any remaining holes in the image
bw = imfill(bw,'holes');

% filter out every object except for the largest one
bw = bwareafilt(bw,1);

% find the area of the projected pecan
s = regionprops(bw,'ConvexArea','BoundingBox');
area = pecan_calibration(s(1).ConvexArea,'area');

% find length and width of pecan
dims = pecan_calibration(s(1).BoundingBox,'distance');

% remove shift in box
dims = dims(3:4);
length = min(dims);
width = max(dims);

% bounding box info in terms of pixels
bounding_box = s(1).BoundingBox;