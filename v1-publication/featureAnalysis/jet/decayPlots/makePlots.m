clear; close all; clc;

% Load data
load C:\Users\parke\OneDrive\Documents\GitHub\Fuel-Processing\featureAnalysis\jet\datastores\rawData.mat

% Prepare needed vectors and matrices
rawData = table2array(rawData);
nameVec = ["", "7629_0", "7629_1", "7629_2", "4734_0", "4734_1", "4734_2", "10153_0", "10153_1", "10153_2" ...
                              "6308_0", "6308_1", "6308_2", "6169_0", "6169_1", "6169_22", "7719_0", "7719_1", "7719_2", "7718_0", "7718_1", " 7718_2", ...
                              "7720_0", "7720_1", "7720_2", "4658_0", "4658_1", "4658_2", "13690_0", "13690_1", "13690_2", "5729_0", "5729_1", "5729_2", ...
                              "10325_0", "10325_1", "10325_2", "10289_0", "10289_1", "10289_2", "10264_0", "10264_1", "10264_2", "10151_0", "10151_1", "10151_2"
                              ];
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
    plot(timeData,log(rawData(:,i)),'r','LineWidth',1);
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
frac = exp(-4);

for i = 2:width(rawData)
    y = rawData(:,i);
    val = y(1)*frac;
    diff = y - val;
    locs = find(diff<0.0001);
    xFrac = x(1:locs(1));
    yFrac = y(1:locs(1));
    
    figure 
    f = fit(xFrac,yFrac,'exp1');
    yhat = f.a*exp(f.b*xFrac);
    hold on
    scatter(xFrac,yFrac,5,'b','filled')
    plot(xFrac,yhat,'r','LineWidth',1)
    % plot(xFrac,log(yFrac),'r','LineWidth',1)
    grid on
    axis tight
    xlabel('Time (s)')
    ylabel('Voltage (V)')
    ref = convertStringsToChars(nameVec(i));
    title(ref);
end

%% Test2
close all

x = timeData;
frac = exp(-7);

for i = 2:width(rawData)
    y = rawData(:,i);
    val = y(1)*frac;
    diff = y - val;
    locs = find(diff<0.0001);
    xFrac = x(1:locs(1));
    yFrac = y(1:locs(1));
    
    figure 
    plot(xFrac,log(yFrac),'r','LineWidth',1)
end