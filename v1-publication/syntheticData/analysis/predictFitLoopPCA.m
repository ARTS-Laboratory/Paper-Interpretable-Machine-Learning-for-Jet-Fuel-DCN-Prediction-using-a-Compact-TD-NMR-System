%% Loop and save models
clear; close all; clc;
cd C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\syntheticData\analysis\temp
rng(1);

addpath('C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\syntheticData\functions')

% loop parameters
frac = 0.05:0.01:0.2;
N = 10:10:100;

m = length(frac);
n = length(N);

% preallocate 
rmseMat = ones(m,n);    
oobMat = ones(m,n);

tic
fprintf('Num cycles to complete: %d\n',n)
fprintf('Iterations per cycle: %d\n',m)
for i = 1:n
    fprintf('--------------------------------\n')
    fprintf('Cycle %d\n',i)
    fprintf('--------------------------------\n')
    for j = 1:m
        fprintf('Fraction %.2f',frac(j))
        
        % format training data 
        [Xtrain,Ytrain,coeff,mu] = formatTrainingData(1,frac(j),N(i),1);

        if i ~= 1 && j ~= 1
            coffMat = (coeffMat + coeff)/2;
            muMat = (muMat + mu)/2;
        else
            coeffMat = coeff;
            muMat = mu;
        end

        % fit model
        t = templateTree('PredictorSelection','allsplits','Surrogate','on');
        rng(1); 

        options.ShowPlots = false;
        options.Verbose = 0;
        options.Optimizer = 'bayesopt';
        model = fitrensemble(Xtrain,Ytrain,'Method','Bag',...
            'OptimizeHyperparameters',{'NumLearningCycles','MinLeafSize','MaxNumSplits','NumVariablesToSample'},...
            'HyperparameterOptimizationOptions',options,'Learners',t);

        % calculate OOB error
        oobMat(j,i) = model.oobLoss;
        
        % calculate RMSE on test data
        [Xtest,Ytest,~] = formatTestData(frac(j));
        Xtest = table2array(Xtest);
        features = (Xtest - muMat)*coeffMat(:,1:2);
        DCN = table2array(Ytest);
        preds = predict(model,features);
        residuals = abs(preds-DCN);
        rmseMat(j,i) = sqrt(1/height(features)*sum(residuals.^2));

        fprintf('   RMSE: %.2f   OOB Erorr: %.2f\n',rmseMat(j,i),oobMat(j,i))

        % save model
        ref = sprintf('model_%d_%.2f.mat',N(i),frac(j));
        save(ref,'model')
    end
end
fprintf('Fitting Complete!\n')
toc

%% test model
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\syntheticData\analysis\temp\model_10_0.20.mat

[Xtest,Ytest,names] = formatTestData(0.14);
% Xtest = Xtest(:,1:5);
features = table2array(Xtest);
DCN = table2array(Ytest);
preds = predict(model,features);

pTable = array2table([names DCN preds]);
pTable.Properties.VariableNames = {'POSF','DCN','Prediction'}


