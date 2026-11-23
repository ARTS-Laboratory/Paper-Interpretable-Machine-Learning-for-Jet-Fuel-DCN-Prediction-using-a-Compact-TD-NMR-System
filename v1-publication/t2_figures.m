clear; close all; clc;

load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\syntheticData\datastores\jetDataMat.mat
addpath('C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\syntheticData\functions')

time = jetDataMat(:,1);
t2Data = jetDataMat(:,2);

sz = 5;
plot(time,t2Data,'LineWidth',2)
box on; axis tight;
xticks([])
yticks([])
ax = gca; ax.FontSize = 15; ax.FontName = 'times';

[features,xFrac,yFrac] = featuresFromFrac(time,t2Data,0.24);
features

figure 
d = linspace(min(xFrac),max(xFrac),1000);
a = features(1); b = features(2);
p1 = plot(xFrac,a*exp(b*xFrac),'k--','LineWidth',3);
hold on
p2 = plot(xFrac,yFrac,'LineWidth',2,'Color',[0 0.4470 0.7410]);
uistack(p2,'bottom')
box on; axis tight;
xticks([])
yticks([])
ax = gca; ax.FontSize = 15; ax.FontName = 'times';

%%
clear; close all; clc;

load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\dcnPredictor\outputs\models\mean_stdev_model_500_0.23.mat

mdl = model.Trees{1};
view(mdl,mode="graph")
