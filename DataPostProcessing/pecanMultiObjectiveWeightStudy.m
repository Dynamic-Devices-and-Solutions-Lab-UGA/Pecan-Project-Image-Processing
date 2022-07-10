function [] = pecanMultiObjectiveWeightStudy(ind)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Explore the weight parameter space
%
% Author: Dani Agramonte
% Last Updated: 05.30.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %% Initialize MATLAB
% 
% clear variables; % Clear variables
% workspace;  % Make sure the workspace panel is showing.
% clear('textprogressbar'); % clear persistent vars in textprogressbar

%% File variables

% choose what to study
% ind = 5;

%% Output file name

outFileNames = {'MHParetoOptim_Phi15_MaterialSteel.mat',...
                'MHParetoOptim_Phi30_MaterialDurableResin.mat',...
                'MHParetoOptim_Phi30_MaterialSteel.mat',...
                'MHParetoOptim_Phi45_MaterialSteel.mat',...
                'VEParetoOptim_Phi15_MaterialSteel.mat',...
                'VEParetoOptim_Phi30_MaterialDurableResin.mat',...
                'VEParetoOptim_Phi30_MaterialSteel.mat',...
                'VEParetoOptim_Phi45_MaterialSteel.mat'};

%% Study Parameters


% Data folder
dataFolder = dir(fullfile(projectPath,'DataPostProcessing','LowessFits','*.mat'));

% define pairing for integrity and shellability fits
pairing = [1 5;...
           2 6;...
           3 7;...
           4 8;...
           9 13;...
           10 14;...
           11 15;...
           12 16];

% get paths
pmi_path = fullfile(dataFolder(pairing(ind,1)).folder,dataFolder(pairing(ind,1)).name);
ps_path = fullfile(dataFolder(pairing(ind,2)).folder,dataFolder(pairing(ind,2)).name);

% size of study - square this value for number of points
n_study = 40;

% smallest weight to consider
w_start = 0.1;

% largest weight to consider
w_finish = 10;


%% Main script

% define parameter space
w1 = linspace(w_start,w_finish,n_study);
w2 = linspace(w_start,w_finish,n_study);

% initialize output variables
sol = zeros(n_study,n_study,2);
solval = zeros(n_study,n_study,2);

% initialize matrix of starting values based on values in previous study
x01 = 647*ones(n_study,n_study);
x02 = 58*ones(n_study,n_study);

% size of window - tune if necessary
s = 5;

% textprogressbar(pad('Completing Parameter Study:',60));
for i = n_study:-1:1
    for j = n_study:-1:1
        % estimate current progress
        % prog_track = (i-1)*n_study+j;
        % total_iter = n_study^2;
        % textprogressbar(100-100*(prog_track/total_iter),'backwards');
        
        % find optimum value
        [sol(i,j,:),solval(i,j,:)] = pecanMultiobjectiveOptim([w1(i),w2(j)],[x01(i,j),x02(i,j)],pmi_path,ps_path);
        
        % set initial values in x01 and x02 equal to sol 
        x01(i,j) = sol(i,j,1);
        x02(i,j) = sol(i,j,2);
        
        % create zeros matrix with same dimensions as x01/x02
        % zerosInit = zeros(n_study,n_study);
        
        % define current element to be 1
        zerosInd(i,j) = 1;
        
        % dilate zeros_ind with a morphological operation
        zerosMorph = imdilate(zerosInd,strel('square',s));
        
        % average out values 
        x01(logical(zerosMorph)) = (zerosMorph(logical(zerosMorph))*sol(i,j,1)+x01(logical(zerosMorph)))/2;
        x02(logical(zerosMorph)) = (zerosMorph(logical(zerosMorph))*sol(i,j,2)+x02(logical(zerosMorph)))/2;
    end
end
% textprogressbar('terminated');

%% Closeout MATLAB

% get mesh coords
[W1,W2] = meshgrid(w1,w2);

% define path
ParetoOptimPath = fullfile(projectPath,'DataPostProcessing','ParetoOptimization',outFileNames{ind});

save(ParetoOptimPath,'W1','W2','sol','solval')

end