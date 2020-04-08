clc;
clear all;
close all;

%% Initialization
fprintf('Script has started\n');

[data startDate] = getData(); % get the data

%% Cumulative data
cumulativeData = data;
nCumulativeData = length(data);
daySinceStart = 1:nCumulativeData;
initialGuess0 = [1000 0.1 1000]; % initial guess;
predictFor = 100;
predictTimeValues = 1:predictFor;

%% Day wise data
copyCumulative = cumulativeData;
copyCumulative(nCumulativeData) = [];
dayWiseGrowth = cumulativeData-[0 copyCumulative];

%% Fit logistic curve
logisticFunction = @(params,time) funLogistic(params,time);
logisticErrorFunction =@(params,data) errorLogistic(params,data);
logisticParams = fitModel(logisticFunction, logisticErrorFunction,cumulativeData,initialGuess0);

fprintf('Predicted values of K, r and A are %6f, %6f and %6f respectively\n',logisticParams(1),logisticParams(2),logisticParams(3));

%% Prediction

cumulativePrediction = logisticFunction(logisticParams,predictTimeValues);
dayWisePrediction = funWeibull(logisticParams,predictTimeValues);

%% Visualization
fprintf('Visualizing results\n');


%row vector for horizontal axis
date = startDate:startDate+predictFor-1;
dateFormated = datetime(date, 'ConvertFrom', 'datenum', 'Format', 'dd-MM-yyyy');

% Number of infected cases per day........................
figure;
plot(dateFormated,dayWisePrediction,'b','LineWidth',1);
hold on
scatter(startDate:startDate+nCumulativeData-1 ,dayWiseGrowth,30,'b','filled');
ylabel('Infected/day');
legend('Predicted','Actual','Infection rate','Actual','Location','best');
title(sprintf('Coronavirus epidemic in India'));
xlabel('Date');
grid on
hold off

% Total Number of cases..............................................
figure;
plot(dateFormated,cumulativePrediction/1000,'k','LineWidth',2);
hold on;
scatter(startDate:startDate+nCumulativeData-1,cumulativeData./1000,30,'k','filled');

% calculating epidemic phases
[maxInfected inflectionPoint] = max (dayWisePrediction);

cumValAtInflection = cumulativePrediction(inflectionPoint);
p2Start = max(  find( cumulativePrediction<=cumValAtInflection/10 ));
p2End = inflectionPoint+   (inflectionPoint-p2Start) ;
p3End = max(  find(   cumulativePrediction <=   cumulativePrediction(p2End)*2  )  );
p2Start = p2Start + startDate-1;
p2End = p2End + startDate-1;
p3End = p3End + startDate-1;
% plot epidemic phases
ylm = get(gca,'Ylim');  % get y-axes limits
xlm = get(gca,'Xlim');  % get x-axes limits
www = xlm(2);
hhh = ylm(2); 
hold on;
h = plot([inflectionPoint-1+startDate inflectionPoint-1+startDate],[0,hhh],'r','LineWidth',1);
h.Annotation.LegendInformation.IconDisplayStyle = 'off';


h.Annotation.LegendInformation.IconDisplayStyle = 'off';
h = fill([p2Start p2End p2End p2Start],[0 0 hhh hhh],'r','FaceAlpha',0.15,'EdgeColor','none');
h.Annotation.LegendInformation.IconDisplayStyle = 'off';

h.Annotation.LegendInformation.IconDisplayStyle = 'off';
h = fill([p2End p3End p3End p2End],[0 0 hhh hhh],'y','FaceAlpha',0.15,'EdgeColor','none');
h.Annotation.LegendInformation.IconDisplayStyle = 'off';
legend('Predicted','Actual','Total number of cases','Actual','Location','best');
ylabel('Total number of cases (in 1000)');
xlabel('Date');
hold off;








