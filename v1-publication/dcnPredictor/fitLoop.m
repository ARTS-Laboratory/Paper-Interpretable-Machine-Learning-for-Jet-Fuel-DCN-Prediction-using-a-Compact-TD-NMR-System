%% Loop and save models
clear; close all; clc;
cd C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\dcnPredictor\outputs\temp
rng(1);

addpath('C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\dcnPredictor\functions')

% load training data
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\dcnPredictor\datastores\trainData.mat
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\dcnPredictor\datastores\trainDCN.mat

% load test data
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\dcnPredictor\datastores\testData.mat
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\dcnPredictor\datastores\testDCN.mat

% loop parameters
frac = 0.1:0.01:0.3;
ensSize = 100:100:1000;
c = 3;
d = 4;
% e = 7;

m = length(frac);
n = length(ensSize);

% preallocate 
meanOOBMat = ones(m,n);
rmseMat = ones(m,n);

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
        [X,Y,~] = featuresFromFrac(frac(j),trainData,trainDCN,0);
        % trainTable = array2table([X(:,1:2),Y]);
        % trainTable = array2table([X(:,1:2),X(:,c),Y]);
        trainTable = array2table([X(:,1:2),X(:,c),X(:,d),Y]);
        % trainTable = array2table([X(:,1:2),X(:,c),X(:,d),X(:,e),Y]);
        % trainTable = array2table([X,Y]);
        trainTable.Properties.VariableNames = ["Amplitude","Rate","Mean","Stdev","DCN"];

        % fit model
        model = TreeBagger(ensSize(i),trainTable,'DCN','Method','regression',...
            'MinLeafSize',1,'NumPredictorsToSample','all',...
            'PredictorSelection','interaction-curvature','OOBPrediction','on');

        % calculate average OOB error
        meanOOBMat(j,i) = mean(oobError(model));

        % calculate RMSE on test data
        [featureMat,DCN,isJet] = featuresFromFrac(frac(j),testData,testDCN,-1);
        % features = featureMat(:,1:2);
        % features = [featureMat(:,1:2),featureMat(:,c)];
        features = [featureMat(:,1:2),featureMat(:,c),featureMat(:,d)];
        % features = [featureMat(:,1:2),featureMat(:,c),featureMat(:,d),featureMat(:,e)];
        % features = featureMat;
        preds = predict(model,features);
        residuals = abs(preds-DCN);
        rmseMat(j,i) = sqrt(1/height(features)*sum(residuals.^2));

        jetRes = ones(1,10);
        hcRes = ones(1,10);
        for k = 1:length(preds)
            if isJet(k) == 1
                jetRes(k) = abs(preds(k)-DCN(k));
            else
                hcRes(k) = abs(preds(k)-DCN(k));
            end
        end
        
        jetRMSE = sqrt(1/10*sum(jetRes.^2));
        hcRMSE = sqrt(1/10*sum(hcRes.^2));

        % print RMSE to screen
        fprintf('   RMSE: %.2f   Jet: %.2f   HC: %.2f\n',rmseMat(j,i),jetRMSE,hcRMSE)

        % save model
        ref = sprintf('model_%d_%.2f.mat',ensSize(i),frac(j));
        save(ref,'model')
    end
end
fprintf('Fitting Complete!\n')
toc

%% Test best
clc
rng('shuffle')

addpath('C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\dcnPredictor\functions')

% load test data
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\dcnPredictor\datastores\testData.mat
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\dcnPredictor\datastores\testDCN.mat

% load model
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\dcnPredictor\outputs\models\mean_model_1000_0.14.mat
% load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\dcnPredictor\outputs\models\all_model_100_0.24.mat

c = 3;
d = 4;
e = 7;
frac = 0.14;
% frac = 0.24;

% format test data
[featureMat,DCN,isJet] = featuresFromFrac(frac,testData,testDCN,-1);
features = [featureMat(:,1:2),featureMat(:,c)];
% features = [featureMat(:,1:2),featureMat(:,c),featureMat(:,d)];
% features = [featureMat(:,1:2),featureMat(:,c),featureMat(:,d),featureMat(:,e)];
% features = featureMat;
preds = predict(model,features);
residuals = abs(preds-DCN);

% format output/compute RMSE
predMat = [preds DCN residuals];
predTable = array2table(predMat);
predTable.Properties.VariableNames = ["Prediction","DCN","Residual"]

RMSE = sqrt(1/height(features)*sum(residuals.^2))

jetRes = ones(1,10);
hcRes = ones(1,10);
for i = 1:length(preds)
    if isJet(i) == 1
        jetRes(i) = abs(preds(i)-DCN(i));
    else
        hcRes(i) = abs(preds(i)-DCN(i));
    end
end

jetRMSE = sqrt(1/10*sum(jetRes.^2))
hcRMSE = sqrt(1/10*sum(hcRes.^2))

%% Subplot hc predictions
% cla(h1);
% close all;

observations = 1:1:n;

figure
obsSz = 140;
predSz = 120;
n = 10;

hc = find(isJet==0);
hcDCN = DCN(hc);
hcPreds = preds(hc);

% scatter DCN and predictions
% h1 = subplot(2,1,1);
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
        p = plot(obs,vbar,'r','LineWidth',1,'DisplayName','residual');
    else
        p = plot(obs,vbar,'r','LineWidth',1,'HandleVisibility','off');
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
ax.FontSize = 15;
box on; grid on;
% str = sprintf('Hydrocarbon RMSE: %.2f',3.92);
% title(str)

% f = gcf;
% f.Position(3) = f.Position(3)+450;
% lgd = legend('show');
% lgd.Position(1) = 0.95;
% lgd.Position(2) = 0.45;
% lgd.FontSize = 20;

%% save data
ref = 'C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\dcnPredictor\outputs\bestData\';
hcObs = observations;
save(strcat(ref,'hcObs.mat'),'hcObs')
save(strcat(ref,'hcDCN.mat'),'hcDCN')
save(strcat(ref,'hcPreds.mat'),'hcPreds')

%% Subplot jet predictions
% close all

n = 10;
observations = 1:1:n;
obsSz = 140;
predSz = 120;

jet = find(isJet==1);
jetDCN = DCN(jet);
jetPreds = preds(jet);

% scatter DCN and predictions
% h2 = subplot(2,1,2);
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
        p = plot(obs,vbar,'r','LineWidth',1,'DisplayName','residual');
    else
        p = plot(obs,vbar,'r','LineWidth',1,'HandleVisibility','off');
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
ax.FontSize = 15;
box on; grid on;
% str = sprintf('Jet Fuel RMSE: %.2f',6.50);
% title(str)

%% save data
ref = 'C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\dcnPredictor\outputs\bestData\';
jetObs = observations;
save(strcat(ref,'jetObs.mat'),'jetObs')
save(strcat(ref,'jetDCN.mat'),'jetDCN')
save(strcat(ref,'jetPreds.mat'),'jetPreds')

%% RMSE and OOB Error vs. Frac
close; 

frac = 0.01:0.01:0.2;

[m,n] = size(rmseMat);
cmap = colormap(jet(10));

% plot RMSE vs. frac
subplot(2,1,1)
hold on
for i = 1:n
    plot(frac*100,rmseMat(:,i),'LineWidth',1,'color',cmap(i,:));
end
hold off

% format
grid on 
axis tight
box on
xticks([2,4,6,8,10,12,14,16,18,20])
xticklabels([])
ylabel('Model RMSE')
ax = gca;
ax.FontSize = 15;

% plot OOB error vs. Frac
subplot(2,1,2)
hold on
for i = 1:n
    plot(frac*100,meanOOBMat(:,i),'LineWidth',1,'color',cmap(i,:));
end
hold off

% format
grid on 
axis tight
box on
xlabel('Truncation Amplitude (% of initial)')
ylabel('Model OOB Error')
ax = gca;
ax.FontSize = 15;

% add legend
f = gcf;
f.Position(3) = f.Position(3) + 250;
lgd = legend;
lgd.Title.String = 'Forest Size';
lgd.String = {'100','200','300','400','500','600','700','800','900','1000'};
lgd.Position(1) = 0.9;
lgd.Position(2) = 0.22;