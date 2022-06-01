function [sol,solval] = pecanMultiobjectiveOptim(weight,x0,params)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Uses MATLAB's built in multiobjective optimization tools to obtain Pareto optima from pecan fits
%
% Author: Dani Agramonte
% Last Updated: 05.30.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialize MATLAB

% Data folder
folder = 'C:\Users\Dani\Documents\Pecan-Project-Image-Processing\Pecan_Surface_Fits';

% file name
name = sprintf('pecanSurfaceFits-Angle.%d-Material.%s.mat',params.Angle,params.Material);

% set path of where data is located
data_path = fullfile(folder,name);

load(data_path,'PecanMeatIntegrity_sfit','PecanShellability_sfit','lb','ub');

%% Main Function

% create goal
pecanGoal = [-100,-100];

% set remaining parameters as empty
A = [];
b = [];
Aeq = [];
beq = [];

% create options
options = optimoptions('fgoalattain');
options.MaxFunctionEvaluations = 1e5;
options.Display = 'off';
options.UseParallel = true;
options.FiniteDifferenceStepSize = 1e-6;
options.FiniteDifferenceType = 'central';
% options.SpecifyObjectiveGradient = true;
% options.PlotFcn = '';
options.FunctionTolerance = 1e-4;
 
% find max
[sol,solval] = fgoalattain(@pecanMultiObjective,x0,pecanGoal,weight,A,b,Aeq,beq,lb,ub,[],options);

% convert back to proper sign
solval = -solval;
%{
function [y,grad] = pecanMultiObjective(x)

% calcualte function value by evaluating sfit objects
y(1) = -PecanMeatIntegrity_sfit(x(1),x(2));
y(2) = -PecanShellability_sfit(x(1),x(2));

% calculate gradients using MATLAB's built in functionality for sfit objects
grad(1,1:2) = -differentiate(PecanMeatIntegrity_sfit,x(1),x(2));
grad(2,1:2) = -differentiate(PecanShellability_sfit,x(1),x(2));

end
%}
function y = pecanMultiObjective(x)

% calcualte function value by evaluating sfit objects
y(1) = -PecanMeatIntegrity_sfit(x(1),x(2));
y(2) = -PecanShellability_sfit(x(1),x(2));

end

end