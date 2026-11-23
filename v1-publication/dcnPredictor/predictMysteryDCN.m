%% Predict DCN for mystery fuels
clear; close all; clc;

% load data
% load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\dcnPredictor\newFuels\take2.mat
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\dcnPredictor\newFuels\take3.mat

data = table2array(take3);
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\syntheticData\dataForFunc\time.mat

% load model, add function to path
addpath('C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\syntheticData\functions')
% load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\dcnPredictor\outputs\models\all_model_100_0.24.mat
% load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\dcnPredictor\outputs\models\mean_stdev_model_500_0.23.mat
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\syntheticData\analysis\reasonable\model_10_0.18.mat
% load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\syntheticData\analysis\temp\model_10_0.24.mat

true = [37.2,53.4,42.0,53.4]';

figure
hold on
% ix = [3 4 1 2];
ix = [2 3 4 1];
for i = 3:4
    % if i ~= 4 
    %     plot(time,data(:,ix(i)),'LineWidth',1)
    % end
    plot(time,data(:,i),'LineWidth',1)
end
xlabel('time (s)')
ylabel('amplitude (V)')
box on; grid on;
xticks(0:1:5)
ax = gca; ax.FontSize = 6;
ax.FontName = 'serif';
lgd = legend({'CN40',...
              'CN50'});
lgd.ItemTokenSize = [10,10];
lgd.FontName = 'serif';

f = gcf;
f.Units = 'inches';
f.Position(3:4) = [3.25,3];
pbaspect([0.5 0.4 0.5])
% exportgraphics(ax,'test_curves.jpg','Resolution',300) 

% compute features
c = 3;
d = 4;
e = 5;
frac = 0.22;

featureMat = featuresFromFrac(time,data,frac);

% features = featureMat(:,1:3);
% features = [featureMat(:,1:2),featureMat(:,c),featureMat(:,d)];
features = featureMat(:,1:5);
% features = featureMat;

featureMat = array2table(features);
% featureMat.Properties.VariableNames = {'amp.','rate','mean','stdev','RMS','SF','kurt.','skew.','IF','CF'}

% make prediction
predictions = predict(model,features);

outs = [true,predictions];

outs = array2table(outs);
outs.Properties.VariableNames = {'actual','predicted'}
RMSE = rmse(true(3:end),predictions(3:end))