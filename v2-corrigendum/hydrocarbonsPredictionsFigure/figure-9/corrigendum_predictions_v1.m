clear; close all; clc;

hcDCN = [6 47.8 18.9 56.0 14.2];
jetDCN = [30.5 47.3 58.7 31.3 58.1];

[hcDCN, ixHC] = sort(hcDCN);
[jetDCN, ixJET] = sort(jetDCN);

load hcOut.mat
load predictionsOut.mat

hcMeanPreds = hcOut(:,1);
hcStdPreds = hcOut(:,2);

hcMeanPreds = hcMeanPreds(ixHC);
hcStdPreds = hcStdPreds(ixHC);

meanPredictions = predictionsOut(:,1);
stdPredictions = predictionsOut(:,2);

jetMeanPreds = meanPredictions(ixJET);
jetStdPreds = stdPredictions(ixJET);

xmin = 0; xmax = 60;

d = linspace(xmin, xmax, 100);
tiledlayout(2,1,'TileSpacing','tight','Padding','tight'); nexttile
hold on


sz = 15;
boxWidth = 1;
barWidth = 0.5;
shape = 'o';

barLength = 1;
% tSize = 15;

plot(d, d, 'k:', 'DisplayName', 'ideal');

lgd = legend();
lgd.AutoUpdate = 'off';

for i = 1:4
    d = linspace(hcDCN(i)-barLength, hcDCN(i)+barLength, 100);
    barTop = (hcMeanPreds(i) + hcStdPreds(i)) * ones(1,100);
    barBottom  = (hcMeanPreds(i) - hcStdPreds(i)) * ones(1,100);
    yVert = linspace(barBottom(1),barTop(1),100);

    plot(d, barTop, 'k', 'LineWidth', barWidth)
    plot(d, barBottom, 'k', 'LineWidth', barWidth)
    plot(hcDCN(i)*ones(1,100), yVert, 'k', 'LineWidth', barWidth)
end

lgd.AutoUpdate = 'on';

for i = 1:4

    switch i
        case 1
            c = [0 0.4470 0.7410];
            dname = 'toluene';
        case 2
            c = [0.8500 0.3250 0.0980];
            dname = 'iso-cetane';  
        case 3
            c = [0.9290 0.6940 0.1250];
            dname = 'iso-octane';
        case 4
            c = [0.4940 0.1840 0.5560];
            dname = 'n-butylcyclohexane';
    end

    scatter(hcDCN(i), hcMeanPreds(i), sz, shape, 'filled', 'MarkerFaceColor', c, 'LineWidth', boxWidth, 'DisplayName', dname)

end

xlabel({'true DCN', '(a)', ''})
ylabel('predicted DCN')
xlim([xmin, xmax])
ylim([xmin, xmax])
xticks(5:10:65)
yticks(5:10:65)
grid on; box on;
ax = gca; ax.FontSize = 6; ax.FontName = 'serif';

lgd.Location = 'southeast';
pbaspect([1 0.7 1])



% -------------------------------------------------------------------------

nexttile

xmin = 25; xmax = 65;

d = linspace(xmin, xmax, 100);

hold on

barLength = 0.6;

plot(d, d, 'k:', 'DisplayName', 'ideal');

lgd = legend();
lgd.AutoUpdate = 'off';

for i = 1:5
    d = linspace(jetDCN(i)-barLength, jetDCN(i)+barLength, 100);
    barTop = (jetMeanPreds(i) + jetStdPreds(i)) * ones(1,100);
    barBottom  = (jetMeanPreds(i) - jetStdPreds(i)) * ones(1,100);
    yVert = linspace(barBottom(1), barTop(1), 100);

    plot(d, barTop, 'k', 'LineWidth', barWidth)
    plot(d, barBottom, 'k', 'LineWidth', barWidth)
    plot(jetDCN(i)*ones(1,100), yVert, 'k', 'LineWidth', barWidth)
end

lgd.AutoUpdate = 'on';

for i = 1:5

    switch i
        case 1
            c = [0 0.4470 0.7410];
            dname = 'JP-8/Gevo-ATJ';
        case 2
            c = [0.8500 0.3250 0.0980];
            dname = 'Sasol IPK';  
        case 3
            c = [0.9290 0.6940 0.1250];
            dname = 'JP-8';
        case 4
            c = [0.4940 0.1840 0.5560];
            dname = 'HRJ Tallow';
        case 5
            c = [0.4660 0.6740 0.1880];
            dname = 'S-8';
    end

    scatter(jetDCN(i), jetMeanPreds(i), sz, shape, 'filled', 'MarkerFaceColor', c, 'LineWidth', boxWidth, 'DisplayName', dname)

end

xlabel({'true DCN', '(b)'})
ylabel('predicted DCN')
xlim([xmin, xmax])
ylim([xmin, xmax])
xticks(30:5:60)
yticks(30:5:60)
grid on; box on;
ax = gca; ax.FontSize = 6; ax.FontName = 'serif';

lgd.Location = 'southeast';

f = gcf;
f.Units = 'inches';
f.Position(3:4) = [3.25,5.2];
pbaspect([1 0.7 1])

exportgraphics(f,'figure9.jpg','Resolution',300);

