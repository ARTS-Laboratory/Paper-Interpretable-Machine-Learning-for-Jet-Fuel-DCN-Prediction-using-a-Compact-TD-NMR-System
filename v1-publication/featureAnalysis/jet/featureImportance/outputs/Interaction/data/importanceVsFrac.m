%% Plot feature importance vs. fraction of decay data used
clear; close all; clc;
cd C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\featureAnalysis\jet\trees\featureImportance\outputs\Interaction\data
load avgImpOOBMat.mat

frac = 0.01:0.01:0.5;
predictorNames = ["Amplitude","Rate","Mean","Stdev","RMS","SF","Kurtosis","Skewness","IF","CF"];


hold on
for i = 1:10
    plot(frac,avgImpOOBMat(i,:),'LineWidth',2)
end

grid on
box on
axis tight
xlabel('Truncation Amplitude (% of initial)')
ylabel('OOB Importance')
ax = gca;
ax.FontSize = 15;
lgd = legend;
lgd.Title.String = 'Predictor';
lgd.String = predictorNames;
lgd.FontSize = 15;
lgd.Location = 'eastoutside';