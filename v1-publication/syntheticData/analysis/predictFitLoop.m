%% Loop and save models
clear; close all; clc;
cd C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\syntheticData\analysis\temp
rng(1);

addpath('C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\syntheticData\functions')

% loop parameters
frac = 0.05:0.01:0.28;
N = 10:10:100;

m = length(frac);
% n = length(N);
n = 1;

% preallocate 
rmseMat = ones(m,n);    
oobMat = ones(m,n);

tic
% fprintf('Num cycles to complete: %d\n',n)
fprintf('Iterations per cycle: %d\n',m)
for i = 0
    fprintf('--------------------------------\n')
    fprintf('Cycle %d\n',i)
    fprintf('--------------------------------\n')
    i = i + 1;
    for j = 1:m
        fprintf('Fraction %.2f',frac(j))
        
        % format training data 
        [Xtrain,Ytrain,~,~] = formatTrainingData(0,frac(j),N(i+1),0);
        Xtrain = [Xtrain(:,1:5)];

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
        Xtest = [Xtest(:,1:5)];
        features = table2array(Xtest);
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
clear; close all; clc;

load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\syntheticData\analysis\temp\model_10_0.24.mat

[Xtest,Ytest,names] = formatTestData(0.24);
Xtest = Xtest(:,1:5);
features = table2array(Xtest);
DCN = table2array(Ytest);
preds = predict(model,features);

pTable = array2table([names DCN preds]);
pTable.Properties.VariableNames = {'POSF','DCN','Prediction'}

hold on
scatter(1:10,DCN)
scatter(1:10,preds)


