clear; close all; clc;
cd C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\dataForRepo

% hydrocarbon training data
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\featureAnalysis\hc\datastores\rawData.mat
% writetable(rawData,'hcTraining.csv')

% jet fuel training data
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\featureAnalysis\jet\datastores\rawData.mat
% writetable(rawData,'jetTraining.csv');

% test data
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\dcnPredictor\datastores\testData.mat
% writetable(testData,'testData.csv');

% validation data
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\dcnPredictor\newFuels\take3.mat
% writetable(take3,'validationData.csv')