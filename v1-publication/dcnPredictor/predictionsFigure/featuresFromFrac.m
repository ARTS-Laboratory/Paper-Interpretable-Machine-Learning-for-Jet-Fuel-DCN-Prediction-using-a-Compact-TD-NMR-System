function [featureMat,xFrac,yFrac] = featuresFromFrac(time,data,frac)

% preallocate
[~,w] = size(data);
ampVec = ones(w,1);
rateVec = ones(w,1);
meanVec = ones(w,1);
stdVec = ones(w,1);
rmsVec = ones(w,1);
sfVec = ones(w,1);
kurtVec = ones(w,1);
skewVec = ones(w,1);
ifVec = ones(w,1);
cfVec= ones(w,1);

x = time;
for i = 1:w
    y = data(:,i);
    % consider fraction of T2 curve
    s = y(1)*frac;
    diff = y - s;
    locs = find(diff<0.0001);
    xFrac = x(1:locs(1));
    yFrac = y(1:locs(1));
    
    % fit exponential and compute features
    f = fit(xFrac,yFrac,'exp1');
    % ampVec(i) = f.a;
    ampVec(i) = yFrac(1);
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

featureMat = [ampVec rateVec meanVec stdVec rmsVec sfVec kurtVec skewVec ifVec cfVec];
end