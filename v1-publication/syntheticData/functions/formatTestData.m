function [X,Y,names] = formatTestData(frac)
    
    load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\syntheticData\datastores\testData.mat
    load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\syntheticData\datastores\testDCN.mat
    load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\syntheticData\dataForFunc\time.mat

    refs = [7629,7629,4734,4734,10153,10153,6308,6308,6169,6169]';
    
    % get jet fuel data
    t2Data = table2array(testData);
    
    % compute features
    featureMat = featuresFromFrac(time,t2Data,frac);
    
    % generate output
    varNames = {'Amplitude','Rate','|Mean|','Stdev','RMS','SF','Kurtosis','Skewness','IF','CF','DCN'};
    testData = [featureMat, testDCN];
    rp = randperm(size(testData,1));
    testData = testData(rp,:);  % shuffle rows
    names = refs(rp);
    testTable = array2table(testData);
    testTable.Properties.VariableNames = varNames;
    X = testTable(:,1:end-1);
    Y = testTable(:,end);
end