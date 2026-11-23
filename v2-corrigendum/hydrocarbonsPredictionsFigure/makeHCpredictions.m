%% Updated to remove n-heptane/n-dodecane sample
clear; close all; clc;

hcDCN = [6 47.8 18.9 14.2];

load hcData.mat
load time.mat

load models\mean_stdev_model_300_0.14.mat

hcDataCropped = [hcData(:, 1:15), hcData(:, 21:end)];

frac = 0.14;
featureMat = featuresFromFrac(time, hcDataCropped, frac);
featureMat = featureMat(:, 1:4);
predictions = predict(model, featureMat);

meanPredictions = ones(1, 4);
stdPredictions = ones(1, 4);
ix = 1;

for i = 1:5:numel(predictions)
    meanPredictions(ix) = mean(predictions(i:i+4));
    stdPredictions(ix) = std(predictions(i:i+4));
    ix = ix + 1;
end

RMSE = rmse(hcDCN, meanPredictions)
[hcDCN; meanPredictions].'

figure;
grid on; box on; hold on;

plot(0:65, 0:65, 'k:', 'LineWidth', 1, 'DisplayName', 'Ideal')
scatter(hcDCN, meanPredictions, 50, 'filled', 'DisplayName', 'Averages')

xlabel('True DCN')
ylabel('Predicted DCN')

axis([0, 60, 0, 60])
xticks(5:10:60)
yticks(5:10:60)

lgd = legend;
lgd.Location = 'northwest';

