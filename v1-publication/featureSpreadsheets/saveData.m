%% Save all data from fuel quality dataset
clear; clc;
addpath('C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\dcnPredictor\functions');

% load data
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\featureSpreadsheets\hcData.mat
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\featureSpreadsheets\jetData.mat
hcData = table2array(hcData);
jetData = table2array(jetData);

% DCN vectors
hcDCN = [73.45 73.45 73.45 73.45 73.45 100.25 100.25 100.25 47.8 47.8 47.8 47.8 47.8 ...
    6 6 6 6 6 22.475 22.475 22.475 18.9 18.9 18.9 18.9 18.9 64.4 64.4 64.4 ...
    56 56 56 8 8 8 14.2 14.2 14.2 14.2 14.2 66.35 66.35 66.35 19.5 19.5 19.5]';

jetDCN = [31.8 31.8 31.8 31.8 31.8 58.7 58.7 58.7 58.7 58.7 30.5 30.5 30.5 30.5 30.5 ...
    58.1 58.1 58.1 58.1 58.1 47.3 47.3 47.3 47.3 47.3 53.3 53.3 53.3 40 40 40 ...
    58.9 58.9 58.9 47.1 47.1 47.1 37.2 37.2 37.2 58.4 58.4 58.4 50 50 50 40.9 40.9 40.9 ...
    49.6 49.6 49.6 15.5 15.5 15.5]';

% names
hcNames = ["n-Dodecane","n-Dodecane","n-Dodecane","n-Dodecane","n-Dodecane",...
    "n-Hexadecane","n-Hexadecane","n-Hexadecane",...
    "n-Butocyclohexane","n-Butocyclohexane","n-Butocyclohexane","n-Butocyclohexane","n-Butocyclohexane",...
    "Toluene","Toluene","Toluene","Toluene","Toluene","Methylcyclohexane","Methylcyclohexane","Methylcyclohexane",...
    "iso-Octane","iso-Octane","iso-Octane","iso-Octane","iso-Octane",...
    "n-Octane","n-Octane","n-Octane","n-Heptane","n-Heptane","n-Heptane",...
    "1,3,5-Trimethylbenzene","1,3,5-Trimethylbenzene","1,3,5-Trimethylbenzene",...
    "iso-Cetane","iso-Cetane","iso-Cetane","iso-Cetane","iso-Cetane",...
    "n-Decane","n-Decane","n-Decane","n-Propylbenzene","n-Propylbenzene","n-Propylbenzene"]';

jetNames = ["7629","7629","7629","7629","7629","4734","4734","4734","4734","4734",...
    "10153","10153","10153","10153","10153","6308","6308","6308","6308","6308",...
    "6169","6169","6169","6169","6169","7719","7719","7719","7718","7718","7718",...
    "7720","7720","7720","4658","4658","4658","13690","13690","13690","5729","5729","5729",...
    "10325","10325","10325","10289","10289","10289","10264","10264","10264","10151","10151","10151"]';

saveHC = 0;
saveJet = 1;

frac = 0.1:0.01:0.2;
for i = 1:length(frac)

    % pick appropriate spreadsheet
    if saveHC == 1
        filename = 'hydrocarbon_features.xlsx';
        decayData = hcData;
        dcn = hcDCN;
        names = hcNames;
        varNames = ["Name","Amplitude","Rate","Mean","Stdev","RMS","SF","Kurtosis","Skewness","IF","CF","DCN"];
    elseif saveJet == 1
        filename = 'fuel_features.xlsx';
        decayData = jetData;
        dcn = jetDCN;
        names = jetNames;
        varNames = ["POSF","Amplitude","Rate","Mean","Stdev","RMS","SF","Kurtosis","Skewness","IF","CF","DCN"];
    end
    
    % compute features
    [featureMat,DCN] = featuresFromFrac(frac(i),decayData,dcn);
    outMat = [featureMat DCN];
    outTable = [array2table(names) array2table(outMat)];
    outTable.Properties.VariableNames = varNames;

    % write to excel file
    writetable(outTable,filename,'Sheet',i,'Range','B2');
end

