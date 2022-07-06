%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% simple script which shows the steps which pecan property get goes through 
% in its image processing
%
% Author: Dani Agramonte
% Last Updated: 05.29.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

imExamplePath = fullfile(projectPath,['Pecan_Data_Master\Pecan_Data-20220526_145147\'...
    'Pecan_Data-Image_Files\Post_Crack\20220516_142952.jpg']);

% read in image
imExample = imread(imExamplePath);

% crop image
imStep1 = imcrop(imExample,[1500 150 1500 950]);

% convert to grayscale
imStep2 = rgb2gray(imStep1);

% binarize image and invert to create mask
imStep3 = ~imbinarize(imStep2,'adaptive','Sensitivity',0.7);

% perform light opening operation to remove noise
imStep4 = imopen(imStep3,strel('Disk',1));

% perform closing operation
imStep5 = imclose(imStep4,strel('Disk',7));

% fill in remaining holes in image
imStep6 = imfill(imStep5,8,'holes');

% filter out every object except for the largest one
imStep7 = bwareafilt(imStep6,1);

% crop reference rectangle for plotting
rect = [758.5 526.5 216 192];

figure(1)
imshow(imcrop(imStep1,rect))
showMaskAsOverlay(0.2,imcrop(imStep7,rect),'r')