%% Make feature distribution figures
clear; close all; clc;
addpath(genpath('C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\featureAnalysis\functions'))

features = ["amp.","rate","mean","stdev.","RMS","SF","kurt.","skew.","IF","CF"];

hcMat = averageAndComputeHC(0.01);
jetMat = averageAndComputeJet(0.01);
hcTable = array2table(hcMat);

% [S1,AX1,BigAx1,H1,HAx1] = plotmatrix(hcMat);
% figure
% [S2,AX2,BigAx2,H2,HAx2] = plotmatrix(jetMat);

[R1,Pval1,H1] = corrplot(hcMat);
ax = gca; ax.Title.String = '';
% f = gcf;
% f.Units = 'inches';
% f.Position(3:4) = [3.5,3];
% pbaspect([3 1 1])

figure
[R2,Pval2,H2] = corrplot(jetMat);
ax = gca; ax.Title.String = '';
% f = gcf;
% f.Units = 'inches';
% f.Position(3:4) = [3.5,3];
% pbaspect([3 1 1])

sz = 12;
numBins = 8;
for i = 1:10
    for j = 1:10
        if i == j
            H2(i,j).FaceColor = [0.8500 0.3250 0.0980];
            H1(i,j).NumBins = numBins; 
            H2(i,j).NumBins = numBins;  
        else
            H1(i,j).Marker = '*'; H2(i,j).Marker = '*';
            H2(i,j).MarkerFaceColor = [0.8500 0.3250 0.0980];
            H2(i,j).MarkerEdgeColor = [0.8500 0.3250 0.0980];
            H1(i,j).Parent.Children(2).Color = 'k';
            H2(i,j).Parent.Children(2).Color = 'k';
            H1(i,j).Parent.FontName = 'times';
            H2(i,j).Parent.FontName = 'times';
            H1(i,j).Parent.FontSize = 6;
            H2(i,j).Parent.FontSize = 6;
        end
    
        H1(i,j).Parent.XTick = []; H2(i,j).Parent.XTick = [];
        H1(i,j).Parent.YTick = []; H2(i,j).Parent.YTick = [];
    end
end

for k = 1:height(H1)
    H1(k,1).Parent.YLabel.String = features(k);
    H1(k,1).Parent.FontName = 'times';
    H1(k,1).Parent.FontSize = sz; 
    H2(k,1).Parent.YLabel.String = features(k);
    H2(k,1).Parent.FontName = 'times';
    H2(k,1).Parent.FontSize = sz; 

    H1(10,k).Parent.XLabel.String = features(k);
    H1(10,k).Parent.FontName = 'times';
    H1(10,k).Parent.FontSize = sz; 
    H2(10,k).Parent.XLabel.String = features(k);
    H2(10,k).Parent.FontName = 'times';
    H2(10,k).Parent.FontSize = sz; 
end

% sz = 12;
% numBins = 8;
% for i = 1:100
%     % change colors
%     if i <= 10
%         H2(i).FaceColor = [0.8500 0.3250 0.0980];
%         H1(i).NumBins = numBins; H2(i).NumBins = numBins;
%     end
%     S2(i).Color = [0.8500 0.3250 0.0980];
% 
%     % format minor axes
%     AX1(i).XTick = []; AX1(i).YTick = [];
%     AX2(i).XTick = []; AX2(i).YTick = [];
%     AX1(i).FontName = 'times'; AX1(i).FontSize = sz;
%     AX2(i).FontName = 'times'; AX2(i).FontSize = sz;
% end
% 
% % more minor axes formatting
% ix = 10:10:100;
% for j = 1:height(AX1)
%     AX1(ix(j)).XLabel.String = features(j);
%     AX1(j).YLabel.String = features(j);
% 
%     AX2(ix(j)).XLabel.String = features(j);
%     AX2(j).YLabel.String = features(j);
% end

%%
clear; clc;

f = gcf;
num = height(f.Children);

vec = 21:11:109;
for i = 1:num
    ax = f.Children(i);
    ax.FontSize = 6;
    ax.FontName = 'serif';
    % ax.Subtitle.FontSize = 6;
    % i
    % ax.Children
    % if i > 10 && i < 109
    %     if mod(i,11) ~= 0
    %         ax.Children(1).FontSize = 6;
    %     end
    %     if sum(vec == i) == 0
    %         ax.Children(1).FontSize = 6;
    %     end
    % end
end

f.Units = 'inches';
f.Position(3:4) = [6,3];    

% exportgraphics(f,'jet_distributions.pdf','Resolution',300)