function [featureMat,DCN,isJet] = featuresFromFrac(frac,data,dcnVec,new)
%featuresFromFrac(frac,data,dcns) computes ten signal features from only a 
%fraction of T2 decay data. 
%   First parameter (frac) is a fraction representing the cuttoff amplitude for
% decay data. That is, the fraction of initial signal strength at which to
% truncate and compute features.
%   Second parameter (data) is T2 data to be used. This can be a table or
% array where the first column is time data and all other columns are
% samples. 
%  Third parameter (dcnVec) is a vector of DCN values whos entries correspond
%to the columns of decay data in data.
%
%  featureMat is an m x 10 matrix of feature observations, where m =
%  height(data). DCN is the same inputted vector of DCNs but permuted in
%  accordance with the shuffled decay data.

    if istable(data) == 1
        data = table2array(data);
    end
    
    x = data(:,1);
    decayData = data(:,2:end);
    [~,n] = size(decayData);

    if new == 0
        % shuffle data
        r = randperm(n);
        decayData = decayData(:,r);
        DCN = dcnVec(r);
        isJet = 'N/A';
    elseif new == -1
        isJet = [0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1];
        r = randperm(n);
        decayData = decayData(:,r);
        DCN = dcnVec(r);
        isJet = isJet(r);
    else
        DCN = 'N/A';
        isJet = 'N/A';
    end

    % preallocate feature vectors
    ampVec = ones(n,1); rateVec = ones(n,1);
    meanVec = ones(n,1); stdVec = ones(n,1); rmsVec = ones(n,1);
    sfVec = ones(n,1); kurtVec = ones(n,1); skewVec = ones(n,1);
    ifVec = ones(n,1); cfVec = ones(n,1);

    % compute features
    for i = 1:n
        y = decayData(:,i);
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
        
        % peak related
        ifVec(i) = ampVec(i)/meanVec(i);
        cfVec(i) = ampVec(i)/rmsVec(i);
    end

    % output feature matrix
    featureMat = [ampVec rateVec meanVec stdVec rmsVec sfVec kurtVec skewVec ifVec cfVec];
end