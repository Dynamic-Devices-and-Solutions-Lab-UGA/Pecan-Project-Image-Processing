% main data path
dataPath = ['C:\Users\Dani\Documents\Pecan-Project-Image-Processing\Pecan_Data_Master\'...
    'Pecan_Data-20220526_145147\Pecan_Data-Image_Files'];

% possible states
pecState = {'Pre_Crack','Post_Crack'};

% choose state
state = 2;

% get all filepaths
imPaths = dir(fullfile(dataPath,pecState{state}));

% remove any directories
imPaths([imPaths.isdir]) = [];

i = 82;

% image path
imPath = fullfile(imPaths(i).folder,imPaths(i).name);

% rgb image
rgbImage = imread(imPath);

%im = imshow(rgbImage);

%create mask  with draw assisted function
%roi = drawassisted;

%new_mask = createMask(roi);

% Mask the image.
maskedRgbImage = bsxfun(@times, rgbImage, cast(backgroundMask,class(rgbImage)));

measurements = regionprops(backgroundMask, 'BoundingBox', 'Area');

maskedRgbImage = imcrop(maskedRgbImage,measurements.BoundingBox);

newbackgroundMask = imcrop(backgroundMask,measurements.BoundingBox);

fontSize = 10;

% Display the binary image.
subplot(4, 4, 2);
imshow(newbackgroundMask, []);
axis('on', 'image');
caption = sprintf('Background Mask Image');
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');
drawnow;
hp = impixelinfo(); % Set up status line to see values when you mouse over the image.
% Get the face mask
faceMask = imfill(~newbackgroundMask, 'holes');
% Display the binary image.
subplot(4, 4, 3);
imshow(faceMask, []);
axis('on', 'image');
caption = sprintf('Face Mask Image');
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');
drawnow;
hp = impixelinfo(); % Set up status line to see values when you mouse over the image.
% Extract the individual red, green, and blue color channels using imsplit() (introduced in R2018b).
[redChannel, greenChannel, blueChannel] = imsplit(maskedRgbImage);
% Display the color images along the left edge of the figure.
% Display the red image.
subplot(4, 4, 5);
imshow(redChannel, []);
axis('on', 'image');
caption = sprintf('Red Image');
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');
drawnow;
hp = impixelinfo(); % Set up status line to see values when you mouse over the image.
% Display the green image.
subplot(4, 4, 9);
imshow(greenChannel, []);
axis('on', 'image');
caption = sprintf('Green Image');
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');
drawnow;
hp = impixelinfo(); % Set up status line to see values when you mouse over the image.
% Display the blue image.
subplot(4, 4, 13);
imshow(blueChannel, []);
axis('on', 'image');
caption = sprintf('Blue Image');
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');
drawnow;
hp = impixelinfo(); % Set up status line to see values when you mouse over the image.
% Get the histogram of each channel.
redCounts = imhist(redChannel);
redCounts(1) = 0;
greenCounts = imhist(greenChannel);
greenCounts(1) = 0;
blueCounts = imhist(blueChannel);
blueCounts(1) = 0;
% Display the red histogram.
subplot(4, 4, 6);
bar(redCounts);
title('Red Histogram', 'FontSize', fontSize);
xlabel('Red Gray Level', 'FontSize', fontSize);
ylabel('Counts', 'FontSize', fontSize);
ylim([0 max(redCounts)])
grid on;
% Find the mean and median and plot the mean in red and the median in blue.
aveR = mean(redChannel(~faceMask))
medR = median(redChannel(~faceMask))
xline(aveR, 'Color', 'r', 'LineWidth', 2);
xline(double(medR), 'Color', 'm', 'LineWidth', 2);
% Display the green histogram.
subplot(4, 4, 10);
bar(greenCounts);
title('Green Histogram', 'FontSize', fontSize);
xlabel('Green Gray Level', 'FontSize', fontSize);
ylabel('Counts', 'FontSize', fontSize);
ylim([0 max(greenCounts)])
grid on;
% Find the mean and median and plot the mean in red and the median in blue.
aveG = mean(greenChannel(~faceMask))
medG = median(greenChannel(~faceMask))
xline(aveG, 'Color', 'r', 'LineWidth', 2);
xline(double(medG), 'Color', 'b', 'LineWidth', 2); % xline() cannot take integers for some bizarre reason so must cast it to double.
% Display the blue histogram.
subplot(4, 4, 14);
bar(blueCounts);
title('Blue Histogram', 'FontSize', fontSize);
xlabel('Blue Gray Level', 'FontSize', fontSize);
ylabel('Counts', 'FontSize', fontSize);
ylim([0 max(blueCounts)])
grid on;
% Find the mean and median and plot the mean in red and the median in blue.
aveB = mean(blueChannel(~faceMask))
medB = median(blueChannel(~faceMask))
xline(aveB, 'Color', 'r', 'LineWidth', 2);
xline(double(medB), 'Color', 'b', 'LineWidth', 2);
% Get the masks for each color above and below the median.
brightMaskR = (redChannel > medR) & ~faceMask;
brightMaskG = (greenChannel > medG) & ~faceMask;
brightMaskB = (blueChannel > medB) & ~faceMask;
darkMaskR = (redChannel <= medR) & ~faceMask;
darkMaskG = (greenChannel <= medG) & ~faceMask;
darkMaskB = (blueChannel <= medB) & ~faceMask;
% Mask the gray scale images.
% Mask the image using bsxfun() function to multiply the mask by each channel individually.  Works for gray scale as well as RGB Color images.
brightR = bsxfun(@times, redChannel, cast(brightMaskR, 'like', redChannel));
brightG = bsxfun(@times, greenChannel, cast(brightMaskG, 'like', greenChannel));
brightB = bsxfun(@times, blueChannel, cast(brightMaskB, 'like', blueChannel));
darkR = bsxfun(@times, redChannel, cast(darkMaskR, 'like', redChannel));
darkG = bsxfun(@times, greenChannel, cast(darkMaskG, 'like', greenChannel));
darkB = bsxfun(@times, blueChannel, cast(darkMaskB, 'like', blueChannel));
% Display the the bright and dark mask images.
% Display bright and dark Red images.
subplot(4, 4, 7);
imshow(brightR);
axis('on', 'image');
caption = sprintf('Red Bright Image');
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');
drawnow;
hp = impixelinfo(); % Set up status line to see values when you mouse over the image.
subplot(4, 4, 8);
imshow(darkR);
axis('on', 'image');
caption = sprintf('Red Dark Image');
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');
drawnow;
hp = impixelinfo(); % Set up status line to see values when you mouse over the image.
% Display bright and dark Green images.
subplot(4, 4, 11);
imshow(brightG);
axis('on', 'image');
caption = sprintf('Green Bright Image');
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');
drawnow;
hp = impixelinfo(); % Set up status line to see values when you mouse over the image.
subplot(4, 4, 12);
imshow(darkG);
axis('on', 'image');
caption = sprintf('Green Dark Image');
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');
drawnow;
hp = impixelinfo(); % Set up status line to see values when you mouse over the image.
% Display bright and dark Blue images.
subplot(4, 4, 15);
imshow(brightB);
axis('on', 'image');
caption = sprintf('Blue Bright Image');
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');
drawnow;
hp = impixelinfo(); % Set up status line to see values when you mouse over the image.
subplot(4, 4, 16);
imshow(darkB);
axis('on', 'image');
caption = sprintf('Blue Dark Image');
title(caption, 'FontSize', fontSize, 'Interpreter', 'None');
drawnow;
hp = impixelinfo(); % Set up status line to see values when you mouse over the image.
% Get the histogram above and below the median values for each color channel
upperHistR = imhist(redChannel(brightMaskR));
lowerHistR = imhist(redChannel(darkMaskR));
upperHistG = imhist(redChannel(brightMaskG));
lowerHistG = imhist(redChannel(darkMaskG));
upperHistB = imhist(redChannel(brightMaskB));
lowerHistB = imhist(redChannel(darkMaskB));
% % Measure the colors
% propsR = regionprops('table', backgroundMask, redChannel, 'MeanIntensity')
% propsG = regionprops('table', backgroundMask,greenChannel, 'MeanIntensity')
% propsB = regionprops('table', backgroundMask, blueChannel, 'MeanIntensity')
function [BW,maskedRGBImage] = createMask(RGB)
%createMask  Threshold RGB image using auto-generated code from colorThresholder app.
%  [BW,MASKEDRGBIMAGE] = createMask(RGB) thresholds image RGB using
%  auto-generated code from the colorThresholder app. The colorspace and
%  range for each channel of the colorspace were set within the app. The
%  segmentation mask is returned in BW, and a composite of the mask and
%  original RGB images is returned in maskedRGBImage.
% Auto-generated by colorThresholder app on 13-Jun-2020
%------------------------------------------------------
% Convert RGB image to chosen color space
I = rgb2hsv(RGB);
% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.000;
channel1Max = 1.000;
% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.000;
channel2Max = 0.026;
% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.918;
channel3Max = 1.000;
% Create mask based on chosen histogram thresholds
sliderBW = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
	(I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
	(I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
BW = sliderBW;
% Initialize output masked image based on input image.
maskedRGBImage = RGB;
% Set background pixels where BW is false to zero.
maskedRGBImage(repmat(~BW,[1 1 3])) = 0;
end