function [sol,solval] = pecanMultiobjectiveOptim(weight,x0,pmi_path,ps_path)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Uses MATLAB's built in multiobjective optimization tools to obtain Pareto optima from pecan fits
%
% Author: Dani Agramonte
% Last Updated: 07.09.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialize MATLAB

% load integrity data
load(pmi_path,'PecanMeatIntegrity_sfit','var_outIntegrity');

% load shellability data
load(ps_path,'PecanShellability_sfit');

% get parameter space - note that this should be the same for shellability
% and integrity
X1 = var_outIntegrity(:,1);
Y1 = var_outIntegrity(:,2);

% calculate upper and lower bounds
lb = [min(X1), min(Y1)];
ub = [max(X1), max(Y1)];


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