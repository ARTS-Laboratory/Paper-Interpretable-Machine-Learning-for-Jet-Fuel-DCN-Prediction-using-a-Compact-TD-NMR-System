%% Compute difference between data and fitting
clear; close all; clc;
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\pureHC\dataExploration\datastores\rawData.mat
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\pureHC\dataExploration\datastores\amplitudesMat.mat
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\pureHC\dataExploration\datastores\ratesMat.mat
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\pureHC\dataExploration\datastores\hcData.mat

decayData = table2array(rawData);
ix = [1 1 2 2 3 3 4 4 5 5 6 6 7 7 8 8 9 9 10 10 11 11 12 12];

t = decayData(:,1);
diffMat = ones(height(t),24);
for i = 1:24
    ref = hcData{1,ix(i)}.name;
    if mod(i,2) ~= 0
        a = amplitudesMat(ix(i),1);
        r = ratesMat(ix(i),1);
        n = 0;
    else
        a = amplitudesMat(ix(i),2);
        r = ratesMat(ix(i),2);
        n = 1;
    end
    y = decayData(:,i+1);
    yhat = a*exp(-r*t);
    dif = yhat - y;
    diffMat(:,i) = dif;
    % figure
    % plot(t,dif,'LineWidth',1)
    % xlabel('Time (s)')
    % ylabel('Difference Between Fit and Data')
    % str = strcat(ref,sprintf('_%d',n));
    % title(str)
    % f = gcf;
    % filename = strcat(str,'.png');
    % exportgraphics(f,filename,'Resolution',256);
end

%% Frequency content of difference
close all; clc;

L = height(diffMat);
Fs = L/decayData(end,1);

Y = fft(diffMat);

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

ix = [1 1 2 2 3 3 4 4 5 5 6 6 7 7 8 8 9 9 10 10 11 11 12 12];
for i = 1:width(Y)
    ref = hcData{1,ix(i)}.name;
    if mod(i,2)~= 0
        n = 0;
    else
        n = 1;
    end

    P2 = abs(Y(:,i)/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);

    f = Fs*(0:(L/2))/L;
    figure 
    plot(f,P1,'LineWidth',1)
    xlabel('f (Hz)')
    ylabel('Amplitude')
    str = strcat(ref,sprintf('_%d',n));
    title(str)

    % f = gcf;
    % filename = strcat(str,'.png');
    % exportgraphics(f,filename,'Resolution',256);
end

%%
clear; clc; close;
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\pureHC\dataExploration\datastores\amplitudesMat.mat
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\pureHC\dataExploration\datastores\ratesMat.mat

hold on
for i = 1:height(amplitudesMat)
    for j = 1:2
        if j == 1
            c = 'r';
        else
            c = 'b'
        end
        scatter(amplitudesMat(i,j),ratesMat(i,j),30,c,'filled')
    end
end
xlabel('amplitude')
ylabel('decay rate')