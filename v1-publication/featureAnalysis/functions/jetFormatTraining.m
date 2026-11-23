function [X,Y,trainingTable] = jetFormatTraining(frac)
%jetFormatTraining(frac) generates and formats training data for fitting
% regression trees on jet fuel data based on fraction of decay data
% specified by frac.
    load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\featureAnalysis\jet\datastores\DCNs.mat
    jetFeatureMat = averageAndComputeJet(frac);

    % training table info
    varNames = {'Amplitude','Rate','|Mean|','Stdev','RMS','SF','Kurtosis','Skewness','IF','CF','DCN'};
    dcnMat = [DCNs DCNs DCNs DCNs DCNs DCNs]';
    dcnVec = [];
    for i = 1:15
        dcnVec = [dcnVec; dcnMat(:,i);];
    end

    % generate output
    trainingData = [jetFeatureMat dcnVec];
    trainingData = trainingData(randperm(size(trainingData,1)),:);  % shuffle rows
    trainingTable = array2table(trainingData);
    trainingTable.Properties.VariableNames = varNames;
    X = trainingTable(:,1:end-1);
    Y = trainingTable(:,end);
end