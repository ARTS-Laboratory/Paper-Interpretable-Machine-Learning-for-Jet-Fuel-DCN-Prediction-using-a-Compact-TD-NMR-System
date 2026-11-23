function [time,syntheticData,syntheticDCN] = generateSyntheticData(Nsamples,showPlots)
% generate synthetic T2 curves along with associated DCN values

load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\syntheticData\dataForFunc\avgPureComps.mat
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\syntheticData\dataForFunc\time.mat

pureNames = ["nC12","nC16","BCH","toluene","MCH","iC8","nC8","nC7","135TMB","iC16","nC10","nPB"];
t2Data = table2array(avgPureComps);

w = width(avgPureComps);
h = height(avgPureComps);

syntheticData = ones(h,Nsamples);
syntheticDCN = ones(Nsamples,1);

for i = 1:Nsamples

    % random mole fraction ratio
    mf1 = rand(1,1);
    mf2 = 1 - mf1;

    % pick two random pure components
    s1 = randi([1,w],1);
    s2 = randi([1,w],1);
    while s2 == s1
        s2 = randi([1,w],1);
    end

    % mix associated t2 curves
    syntheticData(:,i) = t2Data(:,s1)*mf1 + t2Data(:,s2)*mf2;
    
    % calculate DCN of mixture
    name1 = pureNames(s1);
    name2 = pureNames(s2);
    syntheticDCN(i) = dcnOfMixture(name1,name2,mf1,mf2);

    if showPlots
        % visualize data
        figure
        plot(time,syntheticData(:,i),'LineWidth',2)
        xlabel('time (s)')
        ylabel('voltage (V)')
        charN1 = convertStringsToChars(name1);
        charN2 = convertStringsToChars(name2);
        str = strcat(charN1,'-',charN2,',',sprintf(' ratio = %.2f:%.2f, DCN = %.2f',mf1,mf2,syntheticDCN(i)));
        title(str)
        box on
        ax = gca; ax.FontSize = 10;
    end
end