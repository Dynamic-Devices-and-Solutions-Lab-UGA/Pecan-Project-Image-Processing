%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% simple script which debugs pecan_property_get
%
% Author: Dani Agramonte
% Last Updated: 05.28.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i = 82;

% image path
imPath = fullfile(imPaths(i).folder,imPaths(i).name);

rgbImage = imread(imPath);
% immask(im)

load('C:\Users\Dani\Documents\Pecan-Project-Image-Processing\Gray_Scale_Data\colormap.mat');
factors = [aveR,aveG,aveB]';

% calculate the weighted sum
ypict = sum(bsxfun(@times,im2double(rgbImage),factors),3);
ypict = im2uint8(ypict); % if you want uint8 output

imshow(ypict)


%{
[~,~,~,~,bw,~,~] = pecan_property_get(imPath,'debug','true');

bw_old = bw;

bw = imerode(imdilate(bw, strel('disk',12)), strel('disk',14)); %Dilate with radius 5 and erode with 10

% fill any remaining holes in the image
bw = imfill(bw,'holes');

% filter out every object except for the largest one
bw = bwareafilt(bw,1);

% fill any remaining holes in the image
bw_old = imfill(bw_old,'holes');

% filter out every object except for the largest one
bw_old = bwareafilt(bw_old,1);

%montage({bw_old, bw})
%}

return


% run pecan property get
% pecan_property_get(imPath,'debug','true')

% im = imread(imPath);

% imshow(im)

bounds = ...
    [...
    %0.2259,    0.1276,    0.0748;...
    %0.3822,    0.3038,    0.2097;...
    0.1548,    0.0830,    0.0293...
    ];
modes = 'eq';
compare = 'and';


mask = findpixels(im,modes,bounds);

imshow(mask)



%{
color = [1 1 0.63]*255;

% uniform color fields with class specification
s0 = [50 50]; % output image size
% uint8
cp1 = repmat(permute(uint8(color),[1 3 2]),s0);

imshow(cp1)

%}
