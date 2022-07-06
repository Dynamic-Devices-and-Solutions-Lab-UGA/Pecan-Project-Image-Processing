%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Calculate parameters for geometry model given inputs
%
%
% Author: Dani Agramonte
% Last Updated: 07.05.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

phi = 45;
a = 0.94;
b = 0.522;
depth = 0.4;

d4 = 1.5;
d3 = 0.25;
ir = d4/2-d3;

xrange = 0.4;

m = -tand(phi);
x1 = fminsearch(@(x) objfun(phi,a,b,x),xrange);
y1 = y0(a,b,x1);

xintercept1 = ((ir-y1)/m)+x1;
xintercept2 = ((-y1)/m)+x1;
d2 = 2.54*(xintercept2-(depth+xintercept1));
d1 = 2.54*(depth+xintercept1-a);


function obj = objfun(phi,a,b,x0)

obj = abs(-tand(phi)-slopeEllipse(a,b,x0));

end

function m = slopeEllipse(a,b,x0)

y0 = b*(1-(x0/a).^2).^0.5;
m = -(x0/y0).*(b/a)^2;
end

function y = y0(a,b,x0)
y = b*(1-(x0/a).^2).^0.5;
end

function y = ellipseTan(m,x0,y0,x)

y = y0+m*(x-x0);

end