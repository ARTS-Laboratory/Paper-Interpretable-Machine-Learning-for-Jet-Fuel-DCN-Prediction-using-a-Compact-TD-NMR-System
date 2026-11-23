function [X,Y,coeff,mu] = formatTrainingData(type,frac,N,PCA)

    load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\syntheticData\datastores\jetDataMat.mat
    load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\syntheticData\datastores\jetDCN.mat
    load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\syntheticData\datastores\hcDataMat.mat
    load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\syntheticData\datastores\hcDCN.mat
    load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\syntheticData\datastores\avgJetMat.mat
    load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\syntheticData\datastores\avgJetDCN.mat
    time = jetDataMat(:,1);
    
    switch type
        case 0
            t2Data = jetDataMat(:,2:end);
            DCN = jetDCN;
        case 1
            t2Data = [jetDataMat(:,2:end) hcDataMat(:,2:end)];
            DCN = [jetDCN; hcDCN];
        case 2
             [~,syntheticData,syntheticDCN] = generateSyntheticData(N,0);
             t2Data = [jetDataMat(:,2:end) syntheticData];
             DCN = [jetDCN; syntheticDCN];
        case 3
            [~,syntheticData,syntheticDCN] = generateSyntheticData(N,0);
            t2Data = [jetDataMat(:,2:end) hcDataMat(:,2:end) syntheticData];
            DCN = [jetDCN; hcDCN; syntheticDCN];
        case 4
            [~,syntheticData,syntheticDCN] = generateSyntheticData(N,0);
            t2Data = [avgJetMat syntheticData];
            DCN = [avgJetDCN; syntheticDCN];
        case 5 
            [~,syntheticData,syntheticDCN] = generateSyntheticData(N,0);
            t2Data = [avgJetMat hcDataMat(:,2:end) syntheticData];
            DCN = [avgJetDCN; hcDCN; syntheticDCN];
    end

    featureMat = featuresFromFrac(time,t2Data,frac);

    if PCA
        [coeff,score,~,~,~,mu] = pca(featureMat);
        varNames = {'PC1','PC2','DCN'};
        trainingData = [score(:,1:2), DCN];
        
    else
        varNames = {'Amplitude','Rate','|Mean|','Stdev','RMS','SF','Kurtosis','Skewness','IF','CF','DCN'};
        trainingData = [featureMat, DCN];
        coeff = []; mu = [];
    end
        trainingData = trainingData(randperm(size(trainingData,1)),:);  % shuffle rows
        trainingTable = array2table(trainingData);
        trainingTable.Properties.VariableNames = varNames;
        X = trainingTable(:,1:end-1);
        Y = trainingTable(:,end);
end