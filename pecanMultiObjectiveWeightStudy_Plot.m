%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Plot data obtained in pecanMultiObjectiveWeightStudy
%
% Author: Dani Agramonte
% Last Updated: 05.30.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialize MATLAB

clear variables; % Clear variables
workspace;  % Make sure the workspace panel is showing.
commandwindow();

% Data folder
folder = 'C:\Users\Dani\Documents\Pecan-Project-Image-Processing\Pecan_Surface_Fits';

% file name
name = 'pecanMultiObjectiveWeightStudy-Angle.30-Material.Steel.mat';

% set path of where data is located
data_path = fullfile(folder,name);

load(data_path,'x1','x2','sol','solval');

%% Main script

% get pecan integrity metric
pecanIntegrity = permute(solval(1,:,:),[2 3 1]);

% get shellability metric
pecanShellability = permute(solval(2,:,:),[2 3 1]);

% get optimal mass for each weight
massOpt = permute(sol(1,:,:),[2 3 1]);

% get optimal heigh for each weight
heightOpt = permute(sol(2,:,:),[2 3 1]);


[X1,X2] = meshgrid(x1,x2);
figure(1)
surf(X1,X2,pecanIntegrity,pecanShellability)
xlabel('weight of pecan integrity')
ylabel('weight of pecan shellability')
colormap(jet)

figure(2)
surf(X1,X2,massOpt,heightOpt)
xlabel('weight of pecan integrity')
ylabel('weight of pecan shellability')
colormap(jet)

figure(3)
surf(X1,X2,heightOpt,massOpt)
xlabel('weight of pecan integrity')
ylabel('weight of pecan shellability')
colormap(jet)

