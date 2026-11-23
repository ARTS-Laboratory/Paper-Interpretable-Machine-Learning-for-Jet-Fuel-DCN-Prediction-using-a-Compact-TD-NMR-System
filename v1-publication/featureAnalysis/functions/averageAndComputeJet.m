function jetFeatureMat = averageAndComputeJet(frac)
%averageAndComputeJet(frac) considers only a fraction jet T2 data specified
% by frac. It then averages samples to create 3 "new" runs. 10 signal 
% features are computed from this data and returned in an mxn matrix
% jetFeatureMat where m = floor(height(rawData)*frac) and n = 90.
    load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\featureAnalysis\jet\datastores\rawData.mat
    load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\featureAnalysis\jet\datastores\DCNs.mat
    
    % take fraction of decay data
    rawData = table2array(rawData);
    % h = floor(height(rawData)*frac);
    
    % split time and decay data
    timeData = rawData(:,1);
    decayData = rawData(:,2:end);
    m = height(decayData);
    n = width(decayData);
    
    % create "new" averaged data
    avgMat = ones(m,n);
    for i = 1:3:n
        avgMat(:,i) = (decayData(:,i)+decayData(:,i+1))/2;
        avgMat(:,i+1) = (decayData(:,i)+decayData(:,i+2))/2;
        avgMat(:,i+2) = (decayData(:,i+1)+decayData(:,i+2))/2;
    end
    
    % create new matrix of raw and averaged data
    newDecayData = ones(m,2*n);
    
    newDecayData(:,1:3) = decayData(:,1:3);
    newDecayData(:,7:9) = decayData(:,4:6);
    newDecayData(:,13:15) = decayData(:,7:9);
    newDecayData(:,19:21) = decayData(:,10:12);
    newDecayData(:,25:27) = decayData(:,13:15);
    newDecayData(:,31:33) = decayData(:,16:18);
    newDecayData(:,37:39) = decayData(:,19:21);
    newDecayData(:,43:45) = decayData(:,22:24);
    newDecayData(:,49:51) = decayData(:,25:27);
    newDecayData(:,55:57) = decayData(:,28:30);
    newDecayData(:,61:63) = decayData(:,31:33);
    newDecayData(:,67:69) = decayData(:,34:36);
    newDecayData(:,73:75) = decayData(:,37:39);
    newDecayData(:,79:81) = decayData(:,40:42);
    newDecayData(:,85:87) = decayData(:,43:45);
    
    newDecayData(:,4:6) = avgMat(:,1:3);
    newDecayData(:,10:12) = avgMat(:,4:6);
    newDecayData(:,16:18) = avgMat(:,7:9);
    newDecayData(:,22:24) = avgMat(:,10:12);
    newDecayData(:,28:30) = avgMat(:,13:15);
    newDecayData(:,34:36) = avgMat(:,16:18);
    newDecayData(:,40:42) = avgMat(:,19:21);
    newDecayData(:,46:48) = avgMat(:,22:24);
    newDecayData(:,52:54) = avgMat(:,25:27);
    newDecayData(:,58:60) = avgMat(:,28:30);
    newDecayData(:,64:66) = avgMat(:,31:33);
    newDecayData(:,70:72) = avgMat(:,34:36);
    newDecayData(:,76:78) = avgMat(:,37:39);
    newDecayData(:,82:84) = avgMat(:,40:42);
    newDecayData(:,88:90) = avgMat(:,43:45);
    
    % preallocate feature vectors
    ampVec = ones(90,1); rateVec = ones(90,1);
    meanVec = ones(90,1); stdVec = ones(90,1); rmsVec = ones(90,1);
    sfVec = ones(90,1); kurtVec = ones(90,1); skewVec = ones(90,1);
    ifVec = ones(90,1); cfVec = ones(90,1);
    
    x = timeData;
    % compute metrics
    for i = 1:width(newDecayData)

        y = newDecayData(:,i);
        % consider fraction of decay data
        s = y(1)*frac;
        diff = y - s;
        locs = find(diff<0.0001);
        xFrac = x(1:locs(1));
        yFrac = y(1:locs(1));
    
        % fit exponential
        f = fit(xFrac,yFrac,'exp1');
        ampVec(i) = f.a;
        rateVec(i) = f.b;
    
        % standard metrics
        meanVec(i) = mean(yFrac);
        stdVec(i) = std(yFrac);
        rmsVec(i) = rms(yFrac);
    
        % higher order 
        sfVec(i) = rmsVec(i)/meanVec(i);
        kurtVec(i) = kurtosis(yFrac);
        skewVec(i) = skewness(yFrac);
    
        % peak relatedc
        ifVec(i) = ampVec(i)/meanVec(i);
        cfVec(i) = ampVec(i)/rmsVec(i);
    end
    
    % declare feature matrix
    jetFeatureMat = [ampVec rateVec meanVec stdVec rmsVec sfVec kurtVec skewVec ifVec cfVec];
end