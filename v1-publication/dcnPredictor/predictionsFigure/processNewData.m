clear; close all; clc;

cd 'C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\dcnPredictor\predictionsFigure'
load time.mat

cd 'C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\dcnPredictor\predictionsFigure\newData'
folder = 'C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\dcnPredictor\predictionsFigure\newData';

files = dir(fullfile(folder,'*.csv'));
numFiles = numel(files);

s = 5;
N = 10;

%{
  Columns are as follows:
  JP-8/Gevo-ATJ (x5), JP-8 (x5), S-8 (x5), Sasol IPK (x5), HRJ Tallow (x5)
%}


fuelT2Data = ones(3955-s+1,numFiles);
for i = 1:numFiles 

    t2Data = table2array(readtable(files(i).name,"Range","B1:B3955"));
    t2Data = t2Data(s:end);
    t2Data = movmedian(t2Data,N);

    fuelT2Data(:,i) = t2Data;
       
end

cd 'C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\dcnPredictor\predictionsFigure'

existingData = table2array(readtable('existingCurves.xlsx'));

scaledT2Data = ones(3955-s+1,numFiles);
for i = 1:numFiles
    factor = existingData(1,i) / fuelT2Data(1,i);
    scaledT2Data(:,i) = fuelT2Data(:,i) * factor;
end
