%% Loop, train, and save models (example)
clear; close all; clc;

rng(1);

addpath('functions')

% load training data
load datastores\trainData.mat
load datastores\trainDCN.mat

% load test data
load datastores\testData.mat
load datastores\testDCN.mat

% loop parameters
frac = 0.1:0.01:0.3;
ensSize = 100:100:1000;

m = length(frac);
n = length(ensSize);

% preallocate 
meanOOBMat = ones(m,n);
rmseMat = ones(m,n);

tic
fprintf('Num cycles to complete: %d\n',n)
fprintf('Iterations per cycle: %d\n',m)
for i = 1:n
    fprintf('--------------------------------\n')
    fprintf('Cycle %d\n',i)
    fprintf('--------------------------------\n')
    for j = 1:m
        fprintf('Fraction %.2f',frac(j))
        
        % format training data (using all ten features + DCN)
        [X, Y, ~] = featuresFromFracTrain(frac(j), trainData, trainDCN, 0);

        trainTable = array2table([X, Y]);
        trainTable.Properties.VariableNames = ["Amplitude", "Rate", "Mean"," Stdev", "RMS", ...
                                               "SF", "Kurt", "Skew", "IF", "CF", "DCN"];

        % fit model (interaction type: curvature)
        model = TreeBagger(ensSize(i), trainTable, 'DCN', 'Method', 'regression',...
            'MinLeafSize', 1, 'NumPredictorsToSample', 'all',...
            'PredictorSelection', 'interaction-curvature', 'OOBPrediction','on');

        % calculate average OOB error
        meanOOBMat(j, i) = mean(oobError(model));

        % calculate RMSE on test data
        [features, DCN, isJet] = featuresFromFracTrain(frac(j), testData, testDCN, -1);
        preds = predict(model, features);
        residuals = abs(preds-DCN);
        rmseMat(j,i) = sqrt(1/height(features) * sum(residuals.^2));

        jetRes = ones(1, 10);
        hcRes = ones(1, 10);
        for k = 1:length(preds)
            if isJet(k) == 1
                jetRes(k) = abs(preds(k)-DCN(k));
            else
                hcRes(k) = abs(preds(k)-DCN(k));
            end
        end
        
        jetRMSE = sqrt(1/10 * sum(jetRes.^2));
        hcRMSE = sqrt(1/10 * sum(hcRes.^2));

        % print RMSE to screen
        fprintf('   RMSE: %.2f   Jet: %.2f   HC: %.2f\n', rmseMat(j,i),jetRMSE,hcRMSE)

        % save model
        ref = sprintf('model_%d_%.2f.mat', ensSize(i), frac(j));
        save(ref, 'model')
    end
end
fprintf('Fitting Complete!\n')
toc
