%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DDSL - Pecan Project
% 
% Plot Feret property distributions
%
% Author: Dani Agramonte
% Last Updated: 10.11.22
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all

%% load data
load('FeretProperties.mat')

printFlag = 0;

%% plot settings

fontsize = 26;
tikfontsize = 20;
Position = [300, 150, 750, 750];

% set default interpreter
set(groot,'defaultAxesTickLabelInterpreter','latex');  
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

%% plot distributions with bar graph

%#ok<*AGROW> 

figure;
% min Feret diameter
hminFeret = histogram(minF);
coordsStringminFeret = '';
valsminFeret = hminFeret.Values;
valsminFeret(end+1) = valsminFeret(end);
edgesminFeret = hminFeret.BinEdges;
for i = 1:numel(hminFeret.BinEdges)
    coordsStringminFeret = [coordsStringminFeret sprintf(' (%.2f,%.2f)',edgesminFeret(i),valsminFeret(i))];
end

figure;
% max Feret diameter
hmaxFeret = histogram(maxF);
coordsStringmaxFeret = '';
valsmaxFeret = hmaxFeret.Values;
valsmaxFeret(end+1) = valsmaxFeret(end);
edgesmaxFeret = hmaxFeret.BinEdges;
for i = 1:numel(hmaxFeret.BinEdges)
    coordsStringmaxFeret = [coordsStringmaxFeret sprintf(' (%.2f,%.2f)',edgesmaxFeret(i),valsmaxFeret(i))];
end

figure;
% estimated volume from Feret diameters
hVolEst = histogram(VolEst);
coordsStringVolEst = '';
valsVolEst = hVolEst.Values;
valsVolEst(end+1) = valsVolEst(end);
edgesVolEst = hVolEst.BinEdges;
for i = 1:numel(hVolEst.BinEdges)
    coordsStringVolEst = [coordsStringVolEst sprintf(' (%.2f,%.2f)',edgesVolEst(i),valsVolEst(i))];
end

figure;
% estimated volume from Feret diameters
hDg = histogram(Dg);
coordsStringDg = '';
valsDg = hDg.Values;
valsDg(end+1) = valsDg(end);
edgesDg = hDg.BinEdges;
for i = 1:numel(hDg.BinEdges)
    coordsStringDg = [coordsStringDg sprintf(' (%.2f,%.2f)',edgesDg(i),valsDg(i))];
end

figure;
% estimated surface area from Feret diameters
hSA = histogram(SA);
coordsStringSA = '';
valsSA = hSA.Values;
valsSA(end+1) = valsSA(end);
edgesSA = hSA.BinEdges;
for i = 1:numel(hSA.BinEdges)
    coordsStringSA = [coordsStringSA sprintf(' (%.2f,%.2f)',edgesSA(i),valsSA(i))];
end

figure;
% estimated sphericity from Feret diameters
hSph = histogram(100*Sph);
coordsStringSph = '';
valsSph = hSph.Values;
valsSph(end+1) = valsSph(end);
edgesSph = hSph.BinEdges;
for i = 1:numel(hSph.BinEdges)
    coordsStringSph = [coordsStringSph sprintf(' (%.2f,%.2f)',edgesSph(i),valsSph(i))];
end


%{
fig1 = figure(1);
set(gcf, 'Position',  Position)
% order color according to Cynthia Brewer's research
colororder(linspecer(1));

histogram(VolEst,'FaceColor',winter(1),'FaceAlpha',1)
ax = gca;
ax.FontSize = tikfontsize;
xlabel('$V_r$ [mm\textsuperscript{3}]','FontSize',fontsize)
ylabel('Number of datapoints','FontSize',fontsize)
set(gcf,'color','white')

if printFlag
    export_fig(gcf,fullfile(figurePath,'VrFeret.pdf')) 
end

fig2 = figure(2);
set(gcf, 'Position',  Position)
% order color according to Cynthia Brewer's research
colororder(linspecer(1));
histogram(Dg,'FaceColor',winter(1),'FaceAlpha',1)
ax = gca;
ax.FontSize = tikfontsize;
xlabel('$D_g$ [mm]','FontSize',fontsize)
ylabel('Number of datapoints','FontSize',fontsize)
set(gcf,'color','white')

if printFlag
    export_fig(gcf,fullfile(figurePath,'DgFeret.pdf')) 
end

fig3 = figure(3);
set(gcf, 'Position',  Position)
% order color according to Cynthia Brewer's research
colororder(linspecer(1));
histogram(SA,'FaceColor',winter(1),'FaceAlpha',1)
ax = gca;
ax.FontSize = tikfontsize;
xlabel('$SA$ [mm\textsuperscript{2}]','FontSize',fontsize)
ylabel('Number of datapoints','FontSize',fontsize)
set(gcf,'color','white')

if printFlag
    export_fig(gcf,fullfile(figurePath,'SAFeret.pdf')) 
end

fig4 = figure(4);
set(gcf, 'Position',  Position)
% order color according to Cynthia Brewer's research
% colororder(linspecer(1));
histogram(Sph,'FaceColor',winter(1),'FaceAlpha',1)
ax = gca;
ax.FontSize = tikfontsize;
xlabel('$\varsigma$ [\%]','FontSize',fontsize)
ylabel('Number of datapoints','FontSize',fontsize)
set(gcf,'color','white')

if printFlag
    export_fig(gcf,fullfile(figurePath,'SphFeret.pdf')) 
end
%}