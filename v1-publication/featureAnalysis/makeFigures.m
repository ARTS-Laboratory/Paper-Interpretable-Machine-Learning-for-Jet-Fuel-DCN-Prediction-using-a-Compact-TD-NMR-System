%% Log of relaxation
clear; close all; clc;

% load hc and jet data
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\featureAnalysis\hc\datastores\rawData.mat
hcData = table2array(rawData);
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\featureAnalysis\jet\datastores\rawData.mat
jetData = table2array(rawData);
timeData = jetData(:,1);

% Make log figure
jetNames = ["POSF 10151","POSF 10153","POSF 4658","POSF 6308"];
hcNames = ["methylcyclohexane","n-dodecane","1,3,5-trimethylbenzene","iso-cetane"];

subplot(1,2,2)
hold on
% plot(timeData,log(jetData(:,44)))
% plot(timeData,log(jetData(:,44)))
% plot(timeData,log(jetData(:,8)))
% plot(timeData,log(jetData(:,26)))
% plot(timeData,log(jetData(:,11)))
plot(timeData,jetData(:,44))
plot(timeData,jetData(:,8))
plot(timeData,jetData(:,26))
plot(timeData,jetData(:,11))
xlabel('time (s)')
% ylabel('log of amplitude')
ylabel('amplitude (V)')
% title('Log of T2 Relaxation')
% title('T2 Relaxation Curves')
lgd = legend(jetNames,'Location','northeast');
grid on 
axis tight
box on
ax = gca;
ax.FontName = 'serif';
ax.FontSize = 6;
% ylim([-10,0])
xticks([0,1,2,3,4])
% yticks([-8,-6,-4,-2])
f = gcf;
f.Units = 'inches';
% f.Position(3:4) = [3,2.75];
lgd.ItemTokenSize = [10,10];
lgd.FontName = 'serif';
title('jet fuels','FontSize',6,'FontName','serif','FontWeight','normal')

% pbaspect([0.5 0.4 0.5])
% exportgraphics(ax,'jetT2.jpg','Resolution',300) 

subplot(1,2,1)
hold on
plot(timeData,hcData(:,14))
plot(timeData,hcData(:,35))
plot(timeData,hcData(:,8))
plot(timeData,hcData(:,20))

% hold on
% x = 0.6;
% for col = [14,35,8,20]
%     hcCons = hcData(:,col);
%     maxy = max(hcCons);
%     plot(linspace(0,0.5,1000),ones(1,1000)*maxy,'k','LineWidth',0.5)
%     str = sprintf('%0.2f V',maxy);
%     maxy
%     switch col
%         case 14
%             offset = -0.01;
%         case 35
%             offset = -0.005;
%         case 8
%             offset = 0;
%         case 20
%             offset = 0.01;
%     end
%     text(x,maxy+offset,str,'FontSize',6,'FontName','serif')
% end

% figure
% hold on
% plot(timeData,log(hcData(:,14)))
% plot(timeData,log(hcData(:,35)))
% plot(timeData,log(hcData(:,8)))
% plot(timeData,log(hcData(:,20)))
% plot(timeData,hcData(:,14))
% plot(timeData,hcData(:,35))
% plot(timeData,hcData(:,8))
% plot(timeData,hcData(:,20))
xlabel('time (s)') 
ylabel('amplitude (V)')
% ylabel('log of amplitude')
% yticks([-8,-6,-4,-2])
% yticklabels({'-8','-6','-4','-2'})
% title('Log of T2 Relaxation')
% title('T2 Relaxation Curves')
lgd = legend(hcNames,'Location','northeast');
grid on 
axis tight
box on
ax = gca;
ax.FontName = 'serif';
ax.FontSize = 6;
% ylim([-10,0])
xticks([0,1,2,3,4])
% ylim([0,0.8])
% yticks([-8,-6,-4,-2])
f = gcf;
f.Units = 'inches';
% f.Position(3:4) = [3,2.75];
lgd.ItemTokenSize = [10,10];
lgd.FontName = 'serif';
title('hydrocarbons','FontSize',6,'FontName','serif','FontWeight','normal')

% pbaspect([0.5 0.4 0.5])
% exportgraphics(ax,'hcT2.jpg','Resolution',300) 

% sgtitle('T2 relaxation curves','FontSize',8,'FontName','serif','FontWeight','normal')
f = gcf; f.Units = 'inches'; f.Position(3:4) = [5,2];
% exportgraphics(f,'t2Curves.jpg','Resolution',300)

%% Normalized partial dependence
clear; close all; clc;
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\featureAnalysis\jet\featureImportance\outputs\Interaction\data\pdAvgMat.mat
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\featureAnalysis\jet\featureImportance\outputs\Interaction\data\xAvgMat.mat

names = ["amplitude","rate","mean","std. dev.","RMS","SF","kurtosis","skewness","IF","CF"];

cmap = colormap(turbo(30));
cmap = cmap(1:3:end,:);
ax = axes('colororder',cmap);
hold on
for i = 1:10
    x = xAvgMat(:,i);
    if x(1) < 0
        x = x*-1;
    end
    pd = pdAvgMat(:,i);
    normX  = x/max(x);
    normPD = pd/max(pd);
    plot(normX,normPD,'LineWidth',1)
end

% grid on
box on; grid on;
xlabel('normalized predictor value')
ylabel('normalized DCN')
ax = gca;
ax.FontSize = 6;
% lgd = legend;
% lgd.Title.String = 'feature';
% lgd.String = names;
% lgd.FontSize = 6;
% lgd.FontName = 'serif';
% lgd.NumColumns = 2;
% lgd.Location = 'southeast';
% lgd.ItemTokenSize = [5,5];

% xticks(0.5:0.1:1)
% yticks([0.2,0.4,0.6,0.8,1])

xticks(0.75:0.05:1);
yticks(0.75:0.05:1)

f = gcf;
f.Units = 'inches';
f.Position(3:4) = [3.5,3];
pbaspect([1.5 1 1])
% exportgraphics(ax,'jet_pd.pdf','Resolution',300) 