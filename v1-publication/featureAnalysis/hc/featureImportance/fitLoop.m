%% Fit ensemble of regression trees to varying fractions of hc decay data
clear; close all; clc;
addpath(genpath('C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\featureAnalysis\functions'))
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\featureAnalysis\hc\datastores\DCNs.mat

tic

% parameters
frac = 0.25:0.01:0.45;
l = length(frac);
numCycles = 100:100:1000;
w = length(numCycles);

% preallocate metric stores
R2mat = ones(l,w);
impOOBCell = cell(1,w);
predCell = cell(l,w);
fracAmpMat = ones(36,l);
impOOBMat = ones(10,l);

% partial dependence cells
xAmpCell = cell(1,w); xRateCell = cell(1,w);
xMeanCell = cell(1,w); xStdCell = cell(1,w);
xRMSCell = cell(1,w); xSFCell = cell(1,w);
xKurtCell = cell(1,w); xSkewCell = cell(1,w);
xIFCell = cell(1,w); xCFCell = cell(1,w);

pdAmpCell = cell(1,w); pdRateCell = cell(1,w);
pdMeanCell = cell(1,w); pdStdCell = cell(1,w);
pdRMSCell = cell(1,w); pdSFCell = cell(1,w);
pdKurtCell = cell(1,w); pdSkewCell = cell(1,w);
pdIFCell = cell(1,w); pdCFCell = cell(1,w);

% partial dependence matrices
xAmpMat = ones(100,l); xRateMat = ones(100,l);
xMeanMat = ones(100,l); xStdMat = ones(100,l);
xRMSMat = ones(100,l); xSFMat = ones(100,l);
xKurtMat = ones(100,l); xSkewMat = ones(100,l);
xIFMat = ones(100,l); xCFMat = ones(100,l);

pdAmpMat = ones(100,l); pdRateMat = ones(100,l);
pdMeanMat = ones(100,l); pdStdMat = ones(100,l);
pdRMSMat = ones(100,l); pdSFMat = ones(100,l);
pdKurtMat = ones(100,l); pdSkewMat = ones(100,l);
pdIFMat = ones(100,l); pdCFMat = ones(100,l);

fprintf('Num Cycles: %d\n', w)
fprintf('Iterations per Cycle: %d\n', l)

% loop over forest size
for j = 1:w
    fprintf('--------------------------\n')
    fprintf('Cycle %d\n',j)
    fprintf('--------------------------\n')   
    % loop over fractions
    for i = 1:l
        fprintf('Iteration #%d\n',i)
    
        % format training data
        [X,Y,~] = hcFormatTraining(frac(i));
    
        % fit tree ensemble
        t = templateTree('NumVariablesToSample','all',...
        'PredictorSelection','curvature','Surrogate','on');
        rng(1); 
        Mdl = fitrensemble(X,Y,'Method','Bag','NumLearningCycles',numCycles(j), ...
            'Learners',t);
    
        % performance metrics
        yHat = oobPredict(Mdl);
        R2 = corr(Mdl.Y,yHat)^2;
        impOOB = oobPermutedPredictorImportance(Mdl);
        [~,predAssociation] = predictorImportance(Mdl);

        % partial dependence
        [pdAmp,xAmp] = partialDependence(Mdl,'Amplitude');
        [pdRate,xRate] = partialDependence(Mdl,'Rate');
        [pdMean,xMean] = partialDependence(Mdl,'|Mean|');
        [pdStd,xStd] = partialDependence(Mdl,'Stdev');
        [pdRMS,xRMS] = partialDependence(Mdl,'RMS');
        [pdSF,xSF] = partialDependence(Mdl,'SF');
        [pdKurt,xKurt] = partialDependence(Mdl,'Kurtosis');
        [pdSkew,xSkew] = partialDependence(Mdl,'Skewness');
        [pdIF,xIF] = partialDependence(Mdl,'IF');
        [pdCF,xCF] = partialDependence(Mdl,'CF');

        % log results
        R2mat(i,j) = R2;
        impOOBMat(:,i) = impOOB';
        predCell{i,j} = predAssociation;

        xAmpMat(:,i) = xAmp; xRateMat(:,i) = xRate;
        xMeanMat(:,i) = xMean; xStdMat(:,i) = xStd;
        xRMSMat(:,i) = xRMS; xSFMat(:,i) = xSF;
        xKurtMat(:,i) = xKurt; xSkewMat(:,i) = xSkew;
        xIFMat(:,i) = xIF; xCFMat(:,i) = xCF;

        pdAmpMat(:,i) = pdAmp'; pdRateMat(:,i) = pdRate';
        pdMeanMat(:,i) = pdMean'; pdStdMat(:,i) = pdStd';
        pdRMSMat(:,i) = pdRMS'; pdSFMat(:,i) = pdSF';
        pdKurtMat(:,i) = pdKurt'; pdSkewMat(:,i) = pdSkew';
        pdIFMat(:,i) = pdIF'; pdCFMat(:,i) = pdCF';
    end
    impOOBCell{1,j} = impOOBMat;

    xAmpCell{1,j} = xAmpMat; xRateCell{1,j} = xRateMat;
    xMeanCell{1,j} = xMeanMat; xStdCell{1,j} = xStdMat;
    xRMSCell{1,j} = xRMSMat; xSFCell{1,j} = xSFMat;
    xKurtCell{1,j} = xKurtMat; xSkewCell{1,j} = xSkewMat;
    xIFCell{1,j} = xIFMat; xCFCell{1,j} = xCFMat;

    pdAmpCell{1,j} = pdAmpMat; pdRateCell{1,j} = pdRateMat;
    pdMeanCell{1,j} = pdMeanMat; pdStdCell{1,j} = pdStdMat;
    pdRMSCell{1,j} = pdRMSMat; pdSFCell{1,j} = pdSFMat;
    pdKurtCell{1,j} = pdKurtMat; pdSkewCell{1,j} = pdSkewMat;
    pdIFCell{1,j} = pdIFMat; pdCFCell{1,j} = pdCFMat;
end

fprintf('Fitting Complete!\n')
toc

%% Save output data
cd C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\featureAnalysis\hc\trees\featureImportance\outputs\Interaction\data

yayNay = input('Have you changed the current directory?!\n');

if yayNay == 1
save('R2mat.mat','R2mat')
save('frac.mat','frac')
save('impOOBCell.mat','impOOBCell')
save('avgImpOOBMat.mat','avgImpOOBMat')
save('predCell.mat','predCell')
save('avgPredMat.mat','avgPredMat')
save('xAvgMat.mat','xAvgMat')
save('pdAvgMat.mat','pdAvgMat')
disp('Data Saved!')
end

%% Fraction vs. R^2
close;

cmap = colormap(jet(10));
ax = axes('colororder',cmap);
hold on
for k = 1:width(R2mat)
    R2vec = R2mat(:,k);
    plot(frac*100,R2vec,'LineWidth',2)
end

grid on
xlabel('Truncation Amplitude (% of initial)')
ylabel('Model R^2')
ax = gca;
ax.FontSize = 15;
lgd = legend;
lgd.Title.String = 'Forest Size';
lgd.String = {'100','200','300','400','500','600','700','800','900','1000'};
lgd.FontSize = 15;
lgd.Location = 'eastoutside';

%% Average importance (OOB) bar
close;

w = width(impOOBCell);

for i = 1:w
    if i == 1 
        avgImpOOBMat = impOOBCell{1,i};
    else
        avgImpOOBMat = (avgImpOOBMat+impOOBCell{1,i})/2;
    end
end

bar(mean(avgImpOOBMat,2))
title('OOB Predictor Importance Estimates')
xlabel('Predictor Variable')
ylabel('Importance')
h = gca;
h.XTickLabel = Mdl.PredictorNames;
h.XTickLabelRotation = 45;
h.TickLabelInterpreter = 'none';
ax = gca;
ax.FontSize = 15;

%% Average predictor associations
close;

h = height(predCell);
w = width(predCell);
avgPredMat = ones(h,w);
for i = 1:h
    for j = 1:w
        if i == 1 && j == 1
            avgPredMat = predCell{i,j};
        else
            avgPredMat = (avgPredMat+predCell{i,j})/2;
        end
    end
end

imagesc(predAssociation)
title('Predictor Association Estimates')
colorbar
h = gca;
h.XTickLabel = Mdl.PredictorNames;
h.XTickLabelRotation = 45;
h.TickLabelInterpreter = 'none';
h.YTickLabel = Mdl.PredictorNames;
ax = gca;
ax.FontSize = 15;

%% Average partial dependence
close;

w = width(xAmpCell);

for i = 1:w
    if i == 1 
        avgXAmpMat = xAmpCell{1,i}; avgXRateMat = xRateCell{1,i};
        avgXMeanMat = xAmpCell{1,i}; avgXStdMat = xRateCell{1,i};
        avgXRMSMat = xAmpCell{1,i}; avgXSFMat = xRateCell{1,i};
        avgXKurtMat = xAmpCell{1,i}; avgXSkewMat = xRateCell{1,i};
        avgXIFMat = xAmpCell{1,i}; avgXCFMat = xRateCell{1,i};

        avgPDAmpMat = pdAmpCell{1,i}; avgPDRateMat = pdRateCell{1,i};
        avgPDMeanMat = pdAmpCell{1,i}; avgPDStdMat = pdRateCell{1,i};
        avgPDRMSMat = pdAmpCell{1,i}; avgPDSFMat = pdRateCell{1,i};
        avgPDKurtMat = pdAmpCell{1,i}; avgPDSkewMat = pdRateCell{1,i};
        avgPDIFMat = pdAmpCell{1,i}; avgPDCFMat = pdRateCell{1,i};
    else
        avgXAmpMat = (avgXAmpMat + xAmpCell{1,i})/2; 
        avgXRateMat = (avgXRateMat + xRateCell{1,i})/2; 
        avgXMeanMat = (avgXMeanMat + xMeanCell{1,i})/2; 
        avgXStdMat = (avgXStdMat + xStdCell{1,i})/2; 
        avgXRMSMat = (avgXRMSMat + xRMSCell{1,i})/2; 
        avgXSFMat = (avgXSFMat + xSFCell{1,i})/2; 
        avgXKurtMat = (avgXKurtMat + xKurtCell{1,i})/2; 
        avgXSkewMat = (avgXSkewMat + xSkewCell{1,i})/2; 
        avgXIFMat = (avgXIFMat + xIFCell{1,i})/2; 
        avgXCFMat = (avgXCFMat + xCFCell{1,i})/2; 

        avgPDAmpMat = (avgPDAmpMat + pdAmpCell{1,i})/2; 
        avgPDRateMat = (avgPDRateMat + pdRateCell{1,i})/2; 
        avgPDMeanMat = (avgPDMeanMat + pdMeanCell{1,i})/2; 
        avgPDStdMat = (avgPDStdMat + pdStdCell{1,i})/2; 
        avgPDRMSMat = (avgPDRMSMat + pdRMSCell{1,i})/2; 
        avgPDSFMat = (avgPDSFMat + pdSFCell{1,i})/2; 
        avgPDKurtMat = (avgPDKurtMat + pdKurtCell{1,i})/2; 
        avgPDSkewMat = (avgPDSkewMat + pdSkewCell{1,i})/2; 
        avgPDIFMat = (avgPDIFMat + pdIFCell{1,i})/2; 
        avgPDCFMat = (avgPDCFMat + pdCFCell{1,i})/2; 
    end
end

avgXAmp = mean(avgXAmpMat,2); avgXRate = mean(avgXRateMat,2);
avgXMean = mean(avgXMeanMat,2); avgXStd = mean(avgXStdMat,2);
avgXRMS = mean(avgXRMSMat,2); avgXSF = mean(avgXSFMat,2);
avgXKurt = mean(avgXKurtMat,2); avgXSkew = mean(avgXSkewMat,2);
avgXIF = mean(avgXIFMat,2); avgXCF = mean(avgXCFMat,2);

avgPDAmp = mean(avgPDAmpMat,2); avgPDRate = mean(avgPDRateMat,2);
avgPDMean = mean(avgPDMeanMat,2); avgPDStd = mean(avgPDStdMat,2);
avgPDRMS = mean(avgPDRMSMat,2); avgPDSF = mean(avgPDSFMat,2);
avgPDKurt = mean(avgPDKurtMat,2); avgPDSkew = mean(avgPDSkewMat,2);
avgPDIF = mean(avgPDIFMat,2); avgPDCF = mean(avgPDCFMat,2);

xAvgMat = [avgXAmp avgXRate avgXMean avgXStd avgXRMS avgXSF avgXKurt avgXSkew avgXIF avgXCF];
pdAvgMat = [avgPDAmp avgPDRate avgPDMean avgPDStd avgPDRMS avgPDSF avgPDKurt avgPDSkew avgPDIF avgPDCF];

%%
% close

figure
cmap = flip(colormap(jet(10)));
ax = axes('colororder',cmap);
hold on
for i = 1:10
    x = xAvgMat(:,i);
    if x(1) < 0
        x = x*-1;
    end
    pd = pdAvgMat(:,i);
    normX  = x/max(x);
    normPD = pd/max(pd);
    plot(normX,normPD,'LineWidth',2)
end

grid on; box on;
xlabel('normalized predictor value')
ylabel('normalized DCN')
ax = gca;
ax.FontName = 'times';
ax.FontSize = 15;
% lgd = legend;
% lgd.Title.String = 'feature';
% lgd.String = Mdl.PredictorNames;
% lgd.String = {'amplitude','rate','mean','std. dev.','RMS','SF','kurtosis','skewness','IF','CF'};
% lgd.FontSize = 15;
% lgd.Location = 'northwest';
% title('Normalized Partial Dependence')