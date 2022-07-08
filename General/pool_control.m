function pool_control(status)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Simple script which controls pool
%
% Author: Dani Agramonte
% Last Updated: 05.29.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% If no pool, do not create new one.
p = gcp('nocreate'); 

if strcmp(status,'start')
    if isempty(p)
        % start parallel pool
        parpool;
    end
elseif strcmp(status,'end')
    delete(p);
end