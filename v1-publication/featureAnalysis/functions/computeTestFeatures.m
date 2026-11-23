function testFeatureTable = computeTestFeatures(testData)
% computeTestFeatures(testData) computes features from decay data for
% testing regression trees. Input is a table of decay data.
load 

    % convert data to matrix
    rawData = table2array(rawData);
    timeData = rawData(:,1);
    decayData = table2array(testData);
    m = height(decayData);
    n = width(decayData);

    % preallocate feature vectors
    ampVec = ones(n,1); rateVec = ones(n,1);
    meanVec = ones(n,1); stdVec = ones(n,1); rmsVec = ones(n,1);
    sfVec = ones(n,1); kurtVec = ones(n,1); skewVec = ones(n,1);
    ifVec = ones(n,1); cfVec = ones(n,1);

    x = timeData;
    % compute features
    for i = 1:n
    
        % fit exponential
        y = decayData(:,i);
        f = fit(x,y,'exp1');
        ampVec(i) = f.a;
        rateVec(i) = f.b;
    
        % standard metrics
        meanVec(i) = mean(y);
        stdVec(i) = std(y);
        rmsVec(i) = rms(y);
    
        % higher order 
        sfVec(i) = rmsVec(i)/meanVec(i);
        kurtVec(i) = kurtosis(y);
        skewVec(i) = skewness(y);
    
        % peak related
        ifVec(i) = ampVec(i)/meanVec(i);
        cfVec(i) = ampVec(i)/rmsVec(i);
    end
    
    varNames = {'Amplitude','Rate','|Mean|','Stdev','RMS','SF','Kurtosis','Skewness','IF','CF'};
    testFeatureMat = [ampVec rateVec meanVec stdVec rmsVec sfVec kurtVec skewVec ifVec cfVec];
    testFeatureTable = array2table(testFeatureMat);
    testFeatureTable.Properties.VariableNames = varNames;
end