% clear; close all; clc;
close all; clc;

% load T2 data
cd C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\dcnPredictor\predictionsFigure

jetDCN = [30.5 47.3 58.7 31.3 58.1];
% jetDCN = repmat(jetDCN,5,1);
% jetDCN = jetDCN(:);

load scaledT2Data.mat
load time.mat
load existingData.mat
scaledT2Data = existingData;

% load model
load models\all_model_100_0.24.mat
mType = 1;

% load models\mean_model_1000_0.14.mat
% mType = 2;

% load models\mean_stdev_model_300_0.14.mat
% mType = 3;

% load models\mean_stdev_model_500_0.23.mat
% mType = 3;

frac = 0.24;
featureMat = featuresFromFrac(time,scaledT2Data,frac);
predictions = predict(model,featureMat);


meanPredictions = ones(1,5);
stdPredictions = ones(1,5);
ix = 1;

for i = 1:5:numel(predictions)
    meanPredictions(ix) = mean(predictions(i:i+4));
    stdPredictions(ix) = std(predictions(i:i+4));
    ix = ix + 1;
end

RMSE = rmse(jetDCN,meanPredictions)

predictionsOut = [meanPredictions' stdPredictions'];

% for frac = 0.01:0.01:0.30
% 
%     featureMat = featuresFromFrac(time,scaledT2Data,frac);
% 
%     switch mType
%         case 2
%             featureMat = featureMat(:,1:3);
%         case 3
%             featureMat = featureMat(:,1:4);
%     end
% 
%     predictions = predict(model,featureMat);
% 
%     meanPredictions = ones(1,5);
%     stdPredictions = ones(1,5);
%     ix = 1;
% 
%     for i = 1:5:numel(predictions)
%         meanPredictions(ix) = mean(predictions(i:i+4));
%         stdPredictions(ix) = std(predictions(i:i+4));
%         ix = ix + 1;
%     end
% 
%     figure
%     obs = 1:5;
%     scatter(obs,jetDCN)
%     hold on
%     scatter(obs,meanPredictions)
%     RMSE = rmse(jetDCN,meanPredictions);
%     title(sprintf('Frac = %.2f, RMSE = %.2f',frac,RMSE));
% end