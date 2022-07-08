function date = time_unix(string)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% time_unix: get string from picture files and return the time the picture
% was taken in unix time, i.e., time elapsed since midnight January 1st,
% 1970.
%
% Author: Dani Agramonte
% Last Updated: 05.05.2022
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% auxiliary variable to get first half of date info
aux = strsplit(string,'_');

% convert to character array
yyyymmdd = char(aux(1));

% relabel aux variable to get second half of date info
aux = strsplit(char(aux(2)),'.');

% convert to character array
hhmmss = char(aux(1));
date = convertTo(datetime(str2double(yyyymmdd(1:4)),...
    str2double(yyyymmdd(5:6)),str2double(yyyymmdd(7:8)),...
    str2double(hhmmss(1:2)),str2double(hhmmss(3:4)),...
    str2double(hhmmss(5:6))),'posixtime');
    
end % time_unix