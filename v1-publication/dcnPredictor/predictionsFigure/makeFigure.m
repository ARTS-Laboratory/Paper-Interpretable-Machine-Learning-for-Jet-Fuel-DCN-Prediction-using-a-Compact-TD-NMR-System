%% Generate predictions figure
close all; clc;

load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\dcnPredictor\predictionsFigure\data\hcDCN.mat
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\dcnPredictor\predictionsFigure\data\hcPreds.mat
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\dcnPredictor\predictionsFigure\data\jetDCN.mat
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\dcnPredictor\predictionsFigure\data\jetPreds.mat

n = 10;
observations = 1:1:n;

obsSz = 40;
predSz = 20;

hcDCN = [hcDCN(1:5)' hcDCN(7) hcDCN(6) hcDCN(8:end)'];
hcPreds = [hcPreds(1:5)' hcPreds(7) hcPreds(6) hcPreds(8:end)'];

figure
hold on
scatter(observations,hcDCN,obsSz,'k^','filled','DisplayName','actual')
scatter(observations,hcPreds,predSz,'kv','MarkerFaceColor','none','LineWidth',1,'DisplayName','predicted')

% plot residuals
for i = 1:n
    if hcPreds(i) > hcDCN(i)
        vbar = linspace(hcDCN(i),hcPreds(i),100);
    else
        vbar = linspace(hcPreds(i),hcDCN(i),100);
    end
    obs = ones(1,100)*observations(i);
    if i == 1
        p = plot(obs,vbar,'r','LineWidth',0.75,'DisplayName','residual');
    else
        p = plot(obs,vbar,'r','LineWidth',0.75,'HandleVisibility','off');
    end
    uistack(p,'bottom');
end
hold off

% format plot
xlim([0,11])
xticks(0:1:11)
xticklabels({'','1','2','3','4','5','6','7','8','9','10',''})
xlabel('sample')
ylabel('DCN')
ax = gca;
lgd = legend;
lgd.Location = 'northeast';
ax.FontSize = 6; ax.FontName = 'serif';
box on; grid on;
lgd.ItemTokenSize = [10,10];
lgd.FontName = 'serif';

f = gcf;
f.Units = 'inches';
f.Position(3:4) = [3.25,3];
pbaspect([0.3 0.2 0.3])
% exportgraphics(ax,'pure_predictions.pdf','Resolution',300) 

figure
hold on
scatter(observations,jetDCN,obsSz,'k^','filled','DisplayName','actual')
scatter(observations,jetPreds,predSz,'kv','MarkerFaceColor','none','LineWidth',1,'DisplayName','predicted')

% plot residuals
for i = 1:n
    if jetPreds(i) > jetDCN(i)
        vbar = linspace(jetDCN(i),jetPreds(i),100);
    else
        vbar = linspace(jetPreds(i),jetDCN(i),100);
    end
    obs = ones(1,100)*observations(i);
    if i == 1
        p = plot(obs,vbar,'r','LineWidth',0.75,'DisplayName','residual');
    else
        p = plot(obs,vbar,'r','LineWidth',0.75,'HandleVisibility','off');
    end
    uistack(p,'bottom');
end
hold off

% format plot
xlabel('sample')
xlim([0,11])
xticks(0:1:11)
xticklabels({'','1','2','3','4','5','6','7','8','9','10',''})
ylim([28,62])
yticks([30,40,50,60])
ylabel('DCN')
ax = gca;
% lgd = legend;
% lgd.Location = 'northeast';
ax.FontSize = 6; ax.FontName = 'serif';
box on; grid on;    

f = gcf;
f.Units = 'inches';
f.Position(3:4) = [3.25,3];
pbaspect([0.3 0.2 0.3])
% exportgraphics(ax,'jet_predictions.pdf','Resolution',300) 