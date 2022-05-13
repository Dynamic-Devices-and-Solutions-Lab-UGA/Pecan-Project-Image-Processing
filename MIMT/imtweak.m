function outpict = imtweak(inpict,model,changevec)
%   IMTWEAK(INPICT,COLORMODEL,CHANGEVEC)
%       allows simplified manipulation of RGB images or triplets using a 
%       specified color model.  
%
%   INPICT an RGB image, a 4-D image set or a 3-element vector (color triplet)
%       can process multiple triplets (i.e. a color table)
%       so long as triplets are row vectors and array is not 3-D
%
%   COLORMODEL is one of the following 
%       'rgb' for operations on [R G B] in RGB
%       'hsv' for operations on [H S V] in HSV 
%       'hsi' for operations on [H S I] in HSI
%       'hsl' for operations on [H S L] in HSL (as in GIMP <2.9)
%
%       'hsy' for operations on [H S Y] in HSY using polar YPbPr
%       'huslok' for operations on [H S L] in HuSL using polar OKLAB
%       'huslab' for operations on [H S L] in HuSL using CIELCHab
%       'husluv' for operations on [H S L] in HuSL using CIELCHuv
%
%       'hsyp' for operations on [H S Y] in HSYp using polar YPbPr
%       'huslpok' for operations on [H S L] in HuSLp using polar OKLAB
%       'huslpab' for operations on [H S L] in HuSLp using CIELCHab
%       'huslpuv' for operations on [H S L] in HuSLp using CIELCHuv
%
%       'ypbpr' for operations on [Y C H] in polar YPbPr
%       'lchab' for operations on [L C H] in CIELCHab
%       'lchuv' for operations on [L C H] in CIELCHuv
%       'lchsr' for operations on [L C H] in polar SRLAB2
%       'lchok' for operations on [L C H] in polar OKLAB
%   
%       HuSL is an adaptation of various LCH models with normalized chroma. 
%           It is particularly useful for tasks such as avoiding out-of-gamut 
%           values when increasing saturation or when rotating hue at high saturation.
%       HSY method uses polar operations in a normalized luma-chroma model
%           this is conceptually similar to HuSL, but the simpler math makes it about 2-3x as fast.
%       HuSLp and HSYp variants are normalized and constrained to the maximum rotationally-symmetric    
%           subset of the projected RGB space. This means HuSLp/HSYp avoid distortion of the chroma 
%           space when normalizing, preserving the uniformity of the parent space. Unfortunately, this 
%           also means it can only render colors near the neutral axis (pastels). 
%           These methods are mostly useful for relative specification of uniform colors.
%           The four models vary in the degree to which they cover the underlying RGB space:
%           HSYp (59%), HuSLpok (58%), HuSLpuv (54%), and HuSLpab (51%)
%       LCH and YPbPr operations are clamped to the extent of sRGB by data truncation prior to conversion
%           
%   CHANGEVEC is a 3-element vector specifying amounts by which color
%       channels are to be altered.  Scaling is proportional for 
%       all metrics except hue  In the case of hue, specifying 1.00 will
%       rotate hue 360 degrees.  Assuming an HSL model, CHANGEVEC=[0 1 1]
%       results in no change to INPICT.  CHANGEVEC=[0.33 0.5 0.5] results
%       in a 120 degree hue rotation and a 50% decrease of saturation and
%       lightness. For channels other than hue, specifying a negative value 
%       will invert the channel and then apply the specified scaling
%
%
%   CLASS SUPPORT:
%   Supports 'uint8', 'uint16', 'int16', 'single', and 'double'
%
% Webdocs: http://mimtdocs.rf.gd/manual/html/imtweak.html
% See also: IMMODIFY, RGB2HSI, RGB2HSL, RGB2HSY, RGB2HUSL, RGB2LCH, MAXCHROMA.


% While everything has its place, I find little use for the included HSV, HSI, and HSL methods.
% Users may be comfortable with HSL as used in GIMP or LCH as used in Photoshop.
% If the convenience of familiarity is of substantial merit, feel free to use those.
% 
% Unless your goal is to create images with localized brightness inversions, washed-out
% greys or blown-out highlights, I recommend LCH, HuSL or the HSY/YPP method for general hue/saturation adjustment.  
%
% an unbounded LCH method is potentially lossy; that is, color points are not restrained to the limits of
% the RGB gamut for normal datatype ranges.  When out-of-gamut points are clipped on conversion to RGB, 
% they tend to be mapped to locations far away from the point where they left the space.
% While maintaining a LCH working environment and converting to RGB only for final output would be ideal, 
% These tools are all designed to be stand-alone with RGB input and output.  As such, LCH methods are truncated.
% This results in good appearance with one operation, but the consequences of truncation tend to accumulate with
% repeated operations.  For instance, repeated incremental hue adjustment will tend to compress the chroma range of an
% image to the extent of the HuSLp bicone since truncated information is unrecoverable.  HuSL methods may
% be a useful compromise in these cases, despite their chroma distortion.
%
% HuSL and HSY methods are attempts at creating convenient bounded polar color models like HSV or HSL,
% but which utilize transformations of the input RGB space with better color/brightness separation.  
% HuSL is a variant of CIELCH wherein chroma is normalized to the extent of the RGB gamut.  
% Similarly, my own HSY method uses a polar conversion of YPbPr wherein C is normalized to the RGB cube.
% Both methods constrain color points to reduce the effect of clipping, though HSY is much faster.
%
% As to be expected, most of these methods perform poorly for large brightness adjustments.
% For significant brightness adjustments, consider using a levels/curves tool instead (imlnc)

% results for a 900x650 px image with CHANGEVEC=[0.5 0.5 0.5]
% average of last 10 calls out of 11 (in R2019b)
%
%  46ms rgb
% 105ms hsv
% 280ms hsi
% 238ms hsl
% 187ms ypp
% 534ms lchab
% 451ms lchuv
% 488ms lchsr
% 503ms lchok
% 254ms hsy
% 293ms hsyp
% 583ms huslab
% 493ms husluv
% 525ms huslok
% 574ms huslpab
% 453ms huslpuv
% 478ms huslpok

[inpict inclass] = imcast(inpict,'double');

% is the image argument a color or a picture?
if size(inpict,2) == 3 && numel(size(inpict)) < 3
    inpict = ctflop(inpict);
    iscolorelement = 1;
else
    iscolorelement = 0;
end


switch lower(model)
	
	case 'hsy'
		hmax = 360;
		smax = 1;
		lmax = 1;
		method = 'normal'; % can be changed to 'normalcalc' for direct calculation
		outpict = zeros(size(inpict));
		for f = 1:1:size(inpict,4)
			hsypict = rgb2hsy(inpict(:,:,:,f),method);
			hsypict(:,:,1) = mod(hsypict(:,:,1)+changevec(1)*hmax,hmax);
			hsypict(:,:,2) = min((smax*(changevec(2) < 0)+sign(changevec(2))*hsypict(:,:,2))*abs(changevec(2)),smax);
			hsypict(:,:,3) = min((lmax*(changevec(3) < 0)+sign(changevec(3))*hsypict(:,:,3))*abs(changevec(3)),lmax);
			outpict(:,:,:,f) = hsy2rgb(hsypict,method);
		end
		
	case 'hsyp'
		hmax = 360;
		smax = 1.891101;
		lmax = 1;
		method = 'native'; % can be changed to 'nativecalc' for direct calculation
		outpict = zeros(size(inpict));
		for f = 1:1:size(inpict,4)
			hsypict = rgb2hsy(inpict(:,:,:,f),method);
			hsypict(:,:,1) = mod(hsypict(:,:,1)+changevec(1)*hmax,hmax);
			hsypict(:,:,2) = min((smax*(changevec(2) < 0)+sign(changevec(2))*hsypict(:,:,2))*abs(changevec(2)),smax);
			hsypict(:,:,3) = min((lmax*(changevec(3) < 0)+sign(changevec(3))*hsypict(:,:,3))*abs(changevec(3)),lmax);
			outpict(:,:,:,f) = hsy2rgb(hsypict,method);
		end
		
	case 'husluv'
		outpict = processhusl(inpict,changevec,'luv',100,100,360);
		
	case 'huslab'
		outpict = processhusl(inpict,changevec,'lab',100,100,360);
		
	case 'huslok'
		outpict = processhusl(inpict,changevec,'oklab',100,100,360);
		
	case 'huslpuv'
		outpict = processhusl(inpict,changevec,'luvp',100,100,360);
		
	case 'huslpab'
		outpict = processhusl(inpict,changevec,'labp',100,100,360);
		
	case 'huslpok'
		outpict = processhusl(inpict,changevec,'oklabp',100,100,360);
		
	case {'ypp','ypbpr'}
		outpict = processlch(inpict,changevec,'ypbpr',1,0.53351,360);
		
	case 'lchab'
		outpict = processlch(inpict,changevec,'lab',100,134.2,360);
		
	case 'lchuv'
		outpict = processlch(inpict,changevec,'luv',100,180,360);
		
	case 'lchsr'	
		outpict = processlch(inpict,changevec,'srlab',100,103,360);
		
	case 'lchok'	
		outpict = processlch(inpict,changevec,'oklab',100,32.249,360);
		
	case 'rgb'
		outpict = zeros(size(inpict));
		for f = 1:1:size(inpict,4)
			rgbpict = inpict(:,:,:,f);
			
			if abs(changevec(1)) ~= 1
				rgbpict(:,:,1) = min(((changevec(1) < 0)+sign(changevec(1))*rgbpict(:,:,1))*abs(changevec(1)),1);
			end
			if abs(changevec(2)) ~= 1
				rgbpict(:,:,2) = min(((changevec(2) < 0)+sign(changevec(2))*rgbpict(:,:,2))*abs(changevec(2)),1);
			end
			if abs(changevec(3)) ~= 1
				rgbpict(:,:,3) = min(((changevec(3) < 0)+sign(changevec(3))*rgbpict(:,:,3))*abs(changevec(3)),1);
			end
			
			outpict(:,:,:,f) = rgbpict;
		end
		
	case 'hsl'
		hmax = 360;
		outpict = zeros(size(inpict));
		for f = 1:1:size(inpict,4)
			hslpict = rgb2hsl(inpict(:,:,:,f));
			hslpict(:,:,1) = mod(hslpict(:,:,1)+changevec(1)*hmax,hmax);
			hslpict(:,:,2) = min(((changevec(2) < 0)+sign(changevec(2))*hslpict(:,:,2))*abs(changevec(2)),1);
			hslpict(:,:,3) = min(((changevec(3) < 0)+sign(changevec(3))*hslpict(:,:,3))*abs(changevec(3)),1);
			outpict(:,:,:,f) = hsl2rgb(hslpict);
		end
		
	case 'hsi'
		hmax = 360;
		outpict = zeros(size(inpict));
		for f = 1:1:size(inpict,4)
			hsipict = rgb2hsi(inpict(:,:,:,f));
			hsipict(:,:,1) = mod(hsipict(:,:,1)+changevec(1)*hmax,hmax);
			hsipict(:,:,2) = min(((changevec(2) < 0)+sign(changevec(2))*hsipict(:,:,2))*abs(changevec(2)),1);
			hsipict(:,:,3) = min(((changevec(3) < 0)+sign(changevec(3))*hsipict(:,:,3))*abs(changevec(3)),1);
			outpict(:,:,:,f) = hsi2rgb(hsipict);
		end
		
	case 'hsv'
		outpict = zeros(size(inpict));
		for f = 1:1:size(inpict,4)
			hsvpict = rgb2hsv(inpict(:,:,:,f));
			hsvpict(:,:,1) = mod(hsvpict(:,:,1)+changevec(1),1);
			hsvpict(:,:,2) = min(((changevec(2) < 0)+sign(changevec(2))*hsvpict(:,:,2))*abs(changevec(2)),1);
			hsvpict(:,:,3) = min(((changevec(3) < 0)+sign(changevec(3))*hsvpict(:,:,3))*abs(changevec(3)),1);
			outpict(:,:,:,f) = hsv2rgb(hsvpict);
		end
		
	otherwise
		error('IMTWEAK: unknown color model %s',model)
end

if iscolorelement == 1
    outpict = ctflop(outpict);
end

outpict = imcast(outpict,inclass);

end % END OF MAIN SCOPE


function outpict = processlch(inpict,changevec,method,lmax,cmax,hmax)
	outpict = zeros(size(inpict));
	for f = 1:1:size(inpict,4)
		lchpict = rgb2lch(inpict(:,:,:,f),method);
		lchpict(:,:,3) = mod(lchpict(:,:,3)+changevec(3)*hmax,hmax);
		lchpict(:,:,2) = min((cmax*(changevec(2) < 0)+sign(changevec(2))*lchpict(:,:,2))*abs(changevec(2)),cmax);
		lchpict(:,:,1) = min((lmax*(changevec(1) < 0)+sign(changevec(1))*lchpict(:,:,1))*abs(changevec(1)),lmax);
		outpict(:,:,:,f) = lch2rgb(lchpict,method,'truncatelch');
	end
end

function outpict = processhusl(inpict,changevec,method,lmax,smax,hmax)
	outpict = zeros(size(inpict));
	for f = 1:1:size(inpict,4)
		huslpict = rgb2husl(inpict(:,:,:,f),method);
		huslpict(:,:,1) = mod(huslpict(:,:,1)+changevec(1)*hmax,hmax);
		huslpict(:,:,2) = min((smax*(changevec(2) < 0)+sign(changevec(2))*huslpict(:,:,2))*abs(changevec(2)),smax);
		huslpict(:,:,3) = min((lmax*(changevec(3) < 0)+sign(changevec(3))*huslpict(:,:,3))*abs(changevec(3)),lmax);
		outpict(:,:,:,f) = husl2rgb(huslpict,method);
	end
end



