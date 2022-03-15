function a = convex_area_estimator(path)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Image processing script to get estimate of convex area of pecan
%
% Author: Dani Agramonte
% Last Updated: 03.15.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Change the current folder to the folder of this m-file.
if(~isdeployed)
  cd(fileparts(which(mfilename)));
end

clc;  % Clear command window.
workspace;  % Make sure the workspace panel is showing.

currentFolder = pwd;
FullFileName = fullfile(currentFolder,path);

I = imread(FullFileName);
X = imbinarize(I);
bw = ~X(:,:,2);
SE  = strel('Disk',3,4);
bw = imclose(bw, SE);
bw = imfill(bw,'holes');
bw = bwareafilt(bw,1);

imshow(bw)

s = regionprops(bw,'ConvexArea');
a = s(1).ConvexArea;



