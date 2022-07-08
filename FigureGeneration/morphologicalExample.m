%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% simple script which demonstrates morphological opening and closing
%
% Author: Dani Agramonte
% Last Updated: 07.06.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% input mask
inputMask =[...
   0   0   0   0   0   0   0   0   0;...
   0   0   0   0   0   0   0   0   0;...
   0   0   1   1   1   0   0   0   0;...
   0   0   1   1   1   0   0   0   0;...
   0   0   1   1   1   1   1   0   0;...
   0   0   1   1   1   1   1   0   0;...
   0   0   1   1   1   1   1   0   0;...
   0   0   0   0   0   0   0   0   0;...
   0   0   0   0   0   0   0   0   0];

% define simple structural element
se = strel('disk',1);

% calculate our different masks
outMask1 = imdilate(inputMask,se);
outMask2 = imerode(inputMask,se);
outMask3 = imopen(inputMask,se);
outMask4 = imclose(inputMask,se);

set(groot,'defaultAxesTickLabelInterpreter','latex');  
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

fontsize = 22;

figure(1)
imshow(outMask1,'InitialMagnification',5000)
ax = gca;
ax.FontSize = fontsize; 
set(gcf,'color','white')
title('Dilated Image',fontsize)
set(gcf,'Position',[241 201 755 755])
% export_fig dilatedImage.pdf

figure(2)
imshow(outMask2,'InitialMagnification',5000)
ax = gca;
ax.FontSize = fontsize; 
set(gcf,'color','white')
title('Eroded Image',fontsize)
set(gcf,'Position',[241 201 755 755])
% export_fig erodedImage.pdf

figure(3)
imshow(outMask3,'InitialMagnification',5000)
ax = gca;
ax.FontSize = fontsize; 
set(gcf,'color','white')
title('Opened Image',fontsize)
set(gcf,'Position',[241 201 755 755])
% export_fig openedImage.pdf

figure(4)
imshow(outMask4,'InitialMagnification',5000)
ax = gca;
ax.FontSize = fontsize; 
set(gcf,'color','white')
title('Closed Image',fontsize)
set(gcf,'Position',[241 201 755 755])
% export_fig closedImage.pdf

figure(4)
imshow(inputMask,'InitialMagnification',5000)
ax = gca;
ax.FontSize = fontsize; 
set(gcf,'color','white')
title('Original Image',fontsize)
set(gcf,'Position',[241 201 755 755])
% export_fig originalImageMorph.pdf

