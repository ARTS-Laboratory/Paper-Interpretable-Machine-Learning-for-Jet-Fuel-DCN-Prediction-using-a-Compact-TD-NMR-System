%% Group hydrocarbon and jet fuel decay data (including averaged data)
clear; clc;

% load hc data
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\featureAnalysis\hc\datastores\rawData.mat
rawData = table2array(rawData);
timeData = rawData(:,1);
hcData = rawData(:,2:end);

% load jet data
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\featureAnalysis\jet\datastores\rawData.mat
rawData = table2array(rawData);
jetData = rawData(:,2:end);

%  average hc data
[m,n] = size(hcData);

avgMat = ones(m,n);
for i = 1:3:n
    avgMat(:,i) = (hcData(:,i)+hcData(:,i+1))/2;
    avgMat(:,i+1) = (hcData(:,i)+hcData(:,i+2))/2;
    avgMat(:,i+2) = (hcData(:,i+1)+hcData(:,i+2))/2;
end

% create new matrix of raw and averaged data
hcDecay = ones(m,2*n);

hcDecay(:,1:3) = hcData(:,1:3);
hcDecay(:,7:9) = hcData(:,4:6);
hcDecay(:,13:15) = hcData(:,7:9);
hcDecay(:,19:21) = hcData(:,10:12);
hcDecay(:,25:27) = hcData(:,13:15);
hcDecay(:,31:33) = hcData(:,16:18);
hcDecay(:,37:39) = hcData(:,19:21);
hcDecay(:,43:45) = hcData(:,22:24);
hcDecay(:,49:51) = hcData(:,25:27);
hcDecay(:,55:57) = hcData(:,28:30);
hcDecay(:,61:63) = hcData(:,31:33);
hcDecay(:,67:69) = hcData(:,34:36);

hcDecay(:,4:6) = avgMat(:,1:3);
hcDecay(:,10:12) = avgMat(:,4:6);
hcDecay(:,16:18) = avgMat(:,7:9);
hcDecay(:,22:24) = avgMat(:,10:12);
hcDecay(:,28:30) = avgMat(:,13:15);
hcDecay(:,34:36) = avgMat(:,16:18);
hcDecay(:,40:42) = avgMat(:,19:21);
hcDecay(:,46:48) = avgMat(:,22:24);
hcDecay(:,52:54) = avgMat(:,25:27);
hcDecay(:,58:60) = avgMat(:,28:30);
hcDecay(:,64:66) = avgMat(:,31:33);
hcDecay(:,70:72) = avgMat(:,34:36);

% average jet data
[m,n] = size(jetData);

avgMat = ones(m,n);
for i = 1:3:n
    avgMat(:,i) = (jetData(:,i)+jetData(:,i+1))/2;
    avgMat(:,i+1) = (jetData(:,i)+jetData(:,i+2))/2;
    avgMat(:,i+2) = (jetData(:,i+1)+jetData(:,i+2))/2;
end

% create new matrix of raw and averaged data
jetDecay = ones(m,2*n);

jetDecay(:,1:3) = jetData(:,1:3);
jetDecay(:,7:9) = jetData(:,4:6);
jetDecay(:,13:15) = jetData(:,7:9);
jetDecay(:,19:21) = jetData(:,10:12);
jetDecay(:,25:27) = jetData(:,13:15);
jetDecay(:,31:33) = jetData(:,16:18);
jetDecay(:,37:39) = jetData(:,19:21);
jetDecay(:,43:45) = jetData(:,22:24);
jetDecay(:,49:51) = jetData(:,25:27);
jetDecay(:,55:57) = jetData(:,28:30);
jetDecay(:,61:63) = jetData(:,31:33);
jetDecay(:,67:69) = jetData(:,34:36);
jetDecay(:,73:75) = jetData(:,37:39);
jetDecay(:,79:81) = jetData(:,40:42);
jetDecay(:,85:87) = jetData(:,43:45);

jetDecay(:,4:6) = avgMat(:,1:3);
jetDecay(:,10:12) = avgMat(:,4:6);
jetDecay(:,16:18) = avgMat(:,7:9);
jetDecay(:,22:24) = avgMat(:,10:12);
jetDecay(:,28:30) = avgMat(:,13:15);
jetDecay(:,34:36) = avgMat(:,16:18);
jetDecay(:,40:42) = avgMat(:,19:21);
jetDecay(:,46:48) = avgMat(:,22:24);
jetDecay(:,52:54) = avgMat(:,25:27);
jetDecay(:,58:60) = avgMat(:,28:30);
jetDecay(:,64:66) = avgMat(:,31:33);
jetDecay(:,70:72) = avgMat(:,34:36);
jetDecay(:,76:78) = avgMat(:,37:39);
jetDecay(:,82:84) = avgMat(:,40:42);
jetDecay(:,88:90) = avgMat(:,43:45);

% group decay data
t2Data = [timeData hcDecay jetDecay];

% hc DCNs
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\featureAnalysis\hc\datastores\DCNs.mat
dcnMat = [DCNs DCNs DCNs DCNs DCNs DCNs]';
hcDCN = [];
for i = 1:12
    hcDCN = [hcDCN; dcnMat(:,i);];
end

% jet DCNs
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\featureAnalysis\jet\datastores\DCNs.mat
dcnMat = [DCNs DCNs DCNs DCNs DCNs DCNs]';
jetDCN = [];
for i = 1:15
    jetDCN = [jetDCN; dcnMat(:,i);];
end

% group dcn data
dcnVec = [hcDCN; jetDCN];