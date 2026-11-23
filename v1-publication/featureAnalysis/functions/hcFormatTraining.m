function [X,Y,trainingTable] = hcFormatTraining(frac)
%hcFormatTraining(frac) generates and formats training data for fitting
% regression trees on HC data based on fraction of decay data
% specified by frac.
    load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\featureAnalysis\hc\datastores\DCNs.mat
    hcFeatureMat = averageAndComputeHC(frac);

    % training table info
    varNames = {'Amplitude','Rate','|Mean|','Stdev','RMS','SF','Kurtosis','Skewness','IF','CF','DCN'};
    dcnMat = [DCNs DCNs DCNs DCNs DCNs DCNs]';
    dcnVec = [];
    for i = 1:12
        dcnVec = [dcnVec; dcnMat(:,i);];
    end

    % generate output
    trainingData = [hcFeatureMat dcnVec];
    trainingData = trainingData(randperm(size(trainingData,1)),:);  % shuffle rows
    trainingTable = array2table(trainingData);
    trainingTable.Properties.VariableNames = varNames;
    X = trainingTable(:,1:end-1);
    Y = trainingTable(:,end);
end