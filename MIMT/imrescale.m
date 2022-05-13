function outpict = imrescale(inpict,inclass,outclass)
%  OUTPICT=IMRESCALE(INPICT,INCLASS,OUTCLASS)
%     Rescale data based on the explicit assertion of the input and 
%     output data class.  Unlike IMCAST, the class of INPICT is ignored,  
%     and the output class is 'double' regardless of the value of OUTCLASS.
%     IMRESCALE only rescales data.  This may be useful for scaling 
%     threshold values to match the class of an image, instead of rescaling
%     the entire image.
%
%  INPICT is an image or array of any shape or numeric/logical class.
%  INCLASS, OUTCLASS are one of the following strings:
%     'double','single','logical','uint8','uint16','int16'
%
%  Output class is 'double'
%
%  See also: imcast
	
inrg = getrange(inclass);
outrg = getrange(outclass);

outpict = (outrg(2)-outrg(1))*(double(inpict)-inrg(1))/(inrg(2)-inrg(1))+outrg(1);

function thisrange = getrange(thisclass)
	switch thisclass
		case {'single','double','logical'}
			thisrange = [0 1];
		case 'uint8'
			thisrange = [0 255];
		case 'uint16'
			thisrange = [0 65535];
		case 'int16'
			thisrange = [-32768 32767];
		otherwise
			error('IMRESCALE: %s is not a standard image class',thisclass)
	end
end

end



