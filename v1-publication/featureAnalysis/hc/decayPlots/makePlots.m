clear; close all; clc;

% Load data
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\featureAnalysis\hc\datastores\rawData.mat

% Prepare needed vectors and matrices
rawData = table2array(rawData);
nameVec = ["","n-Propylbenzene_0","n-Propylbenzene_1","n-Propylbenzene_2",...
           "Toluene_0", "Toluene_1", "Toluene_2",...
           "1,3,5-Trimethylbenzene_0","1,3,5-Trimethylbenzene_1","1,3,5-Trimethylbenzene_2",...
           "n-Butocyclohexane_0","n-Butocyclohexane_1","n-Butocyclohexane_2",...
           "Methylcyclohexane_0","Methylcyclohexane_1","Methylcyclohexane_2",...
           "iso-Octane_0","iso-Octane_1","iso-Octane_2",...
           "iso-Cetane_0","iso-Cctan" + ...
           "e_1","iso-Cctane_2",...
           "n-Heptane_0","n-Heptane_1","n-Heptane_2",...
           "n-Octane_0","n-Octane_1","n-Octane_2",...
           "n-Decane_0","n-Decane_1","n-Decane_2",...
           "n-Hexadecane_0","n-Hexadecane_1","n-Hexadecane_2",...
           "n-Dodecane_0","n-Dodecane_1","n-Dodecane_2"];
timeData = rawData(:,1);

%% Exponential, time domain
close all

for i = 2:width(rawData)
    figure
    plot(timeData,rawData(:,i),'LineWidth',1);
    grid on
    axis tight
    xlabel('Time (s)')
    ylabel('Voltage (V)')
    ref = convertStringsToChars(nameVec(i));
    title(ref);
    f = gcf;
    filename = strcat(ref,'.png');
    exportgraphics(f,filename,'Resolution',256);
end

%% Logarithmic, time domain
close all

lograwData = [timeData log(rawData(:,2:end))];

for i = 2:width(rawData)
    figure
    plot(timeData,lograwData(:,i),'r','LineWidth',1);
    grid on
    axis tight
    xlabel('Time (s)')
    ylabel('Log Voltage')
    ref = convertStringsToChars(nameVec(i));
    title(ref);
    f = gcf;
    filename = strcat(ref,'.png');
    exportgraphics(f,filename,'Resolution',256);
end

%% Fit exponential to data
close all

x = timeData;

for i = 2:width(rawData)
    y = rawData(:,i);
    f = fit(x,y,'exp1');
    ybar = f.a*exp(f.b*x);
    
    figure
    scatter(x,y,2,'filled')
    hold on
    plot(x,ybar,'LineWidth',1)
    grid on
    axis tight
    xlabel('Time (s)')
    ylabel('Voltage (V)')
    ref = convertStringsToChars(nameVec(i));
    titleStr = strcat(ref,sprintf(', %.2fexp(%.2ft)',f.a,f.b));
    title(titleStr)
    hold off
    filename = strcat(ref,'.png');
    f = gcf;
    exportgraphics(f,filename,'Resolution',256);
end

%% Normalize, take log

hold on
for i = 2:width(rawData)
    yNorm = rawData(:,i)/rawData(1,i);
    plot(timeData,log(yNorm),'LineWidth',1)
    grid on
    axis tight
    xlabel('Time (s)')
    ylabel('Log Normalized Voltage')
    % ref = convertStringsToChars(nameVec(i));
    % title(ref);
    % f = gcf;
    % filename = strcat(ref,'.png');
    % exportgraphics(f,filename,'Resolution',256);
end

%% Test1
close all

x = timeData;
frac = 0.01:0.01:0.9;
resVec = ones(1,length(frac));
ampDiffVec = ones(1,length(frac));
av = ones(1,width(rawData)-1);

for j = 1:length(frac)
    res = 0;
    ampDiff = 0;
    for i = 2:width(rawData)
        y = rawData(:,i);
        val = y(1)*frac(j);
        diff = y - val;
        locs = find(diff<0.0001);
        xFrac = x(1:locs(1));
        yFrac = y(1:locs(1));
        
        % figure 
        f = fit(xFrac,yFrac,'exp1');
        yhat = f.a*exp(f.b*xFrac);
        res = (res + sum((yFrac-yhat).^2))/2;
        ampDiff = (ampDiff + abs(yFrac(1)-yhat(1)))/2;
        % hold on
        % scatter(xFrac,yFrac,5,'b','filled')
        % plot(xFrac,yhat,'r','LineWidth',2)
        % grid on
        % axis tight
        % xlabel('Time (s)')
        % ylabel('Voltage (V)')
        % ref = convertStringsToChars(nameVec(i));
        % title(ref);
        av(i) = abs(yFrac(1)-yhat(1));
    end
    resVec(j) = res;
    ampDiffVec(j) = ampDiff;
end

subplot(2,1,1)
plot(frac*100,resVec,'b','LineWidth',1)
xlabel('Truncation Amplitude (% of initial)')
ylabel('Residual Squared Error')
title('Total Fitting Error')
grid on
axis tight
subplot(2,1,2)
plot(frac*100,ampDiffVec,'r','LineWidth',1)
xlabel('Truncation Amplitude (% of initial)')
ylabel('Difference')
grid on 
axis tight
title('Amplitude Error')
%% Test2
close all

x = timeData;
frac = exp(-3);

for i = 2:width(rawData)
    y = rawData(:,i);
    val = y(1)*frac;
    diff = y - val;
    locs = find(diff<0.0001);
    xFrac = x(1:locs(1));
    yFrac = y(1:locs(1));
    
    f = fit(xFrac,log(yFrac),'poly1');
    yhat = f.p2 + f.p1*xFrac;

    figure 
    hold on
    plot(xFrac,log(yFrac),'b','LineWidth',1)
    plot(xFrac,yhat,'r','LineWidth',2)
end

%% Test 3
close all

x = timeData;

for i = 2:width(rawData)
    y = movmedian(rawData(:,i),200);
    f = fit(x,y,'exp1');
    ybar = f.a*exp(f.b*x);
    
    figure
    scatter(x,y,2,'filled')
    hold on
    plot(x,ybar,'LineWidth',1)
    grid on
    axis tight
    xlabel('Time (s)')
    ylabel('Voltage (V)')
    ref = convertStringsToChars(nameVec(i));
    titleStr = strcat(ref,sprintf(', %.2fexp(%.2ft)',f.a,f.b));
    title(titleStr)
    hold off
    filename = strcat(ref,'.png');
    % f = gcf;
    % exportgraphics(f,filename,'Resolution',256);
end