clear; close all; clc;
% close all; clc;

% load T2 data
cd C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\dcnPredictor\predictionsFigure

load heptaneData.mat

% hcDCN = [8 47.8 18.9 56.0 14.2];
% hcDCN = [6 47.8 18.9 56.0 14.2];
hcDCN = [6 47.8 18.9 73.5 14.2];

load hcData.mat
load time.mat

% load model
% load models\all_model_100_0.24.mat
% mType = 1;

% load models\mean_model_1000_0.14.mat
% mType = 2;

load models\mean_stdev_model_300_0.14.mat
mType = 3;

% load models\mean_stdev_model_500_0.23.mat
% mType = 3;

frac = 0.14;
featureMat = featuresFromFrac(time,hcData,frac);
featureMat = featureMat(:,1:4);
predictions = predict(model,featureMat);

meanPredictions = ones(1,5);
stdPredictions = ones(1,5);
ix = 1;

for i = 1:5:numel(predictions)
    meanPredictions(ix) = mean(predictions(i:i+4));
    stdPredictions(ix) = std(predictions(i:i+4));
    ix = ix + 1;
end

% featureMatNew = featuresFromFrac(time, heptaneData, frac);
% predictionsNew = predict(model, featureMatNew(:, 1:4))
% 
% meanNew = mean(predictionsNew);
% stdNew = std(predictionsNew);
% 
% meanPredictions(4) = meanNew;
% stdPredictions(4) = stdNew;

RMSE = rmse(hcDCN,meanPredictions)

hcOut = [meanPredictions' stdPredictions']

% for frac = 0.01:0.01:0.30
% 
%     featureMat = featuresFromFrac(time,hcData,frac);
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
%     scatter(obs,hcDCN)
%     hold on
%     scatter(obs,meanPredictions)
%     RMSE = rmse(hcDCN,meanPredictions);
%     title(sprintf('Frac = %.2f, RMSE = %.2f',frac,RMSE));
% end