function [sol,solval] = pecanMultiobjectiveOptim(weight,x0)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Uses MATLAB's built in multiobjective optimization tools to obtain Pareto optima from pecan fits
%
% Author: Dani Agramonte
% Last Updated: 05.30.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set path of where data is located
data_path = ['C:\Users\Dani\Documents\Pecan-Project-Image-Processing\'...
    'Pecan_Surface_Fits\PecanSurfaceFits-Angle.30-Material.Steel.mat'];

load(data_path,'PecanMeatIntegrity_sfit','PecanShellability_sfit','lb','ub');

%% Main Function

% create multi objective function, 
pecanMultiObjective = @(x)[-PecanMeatIntegrity_sfit(x(1),x(2));-PecanShellability_sfit(x(1),x(2))];

% create goal
pecanGoal = [-100,-100];

% set remaining parameters as empty
A = [];
b = [];
Aeq = [];
beq = [];

% create options
options = optimoptions('fgoalattain','MaxFunctionEvaluations',1e5,'Display','off',UseParallel,'true');
 
% find max
[sol,solval] = fgoalattain(pecanMultiObjective,x0,pecanGoal,weight,A,b,Aeq,beq,lb,ub,[],options);

% convert back to proper sign
solval = -solval;