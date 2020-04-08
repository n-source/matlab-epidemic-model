function rmsErr = errorLogistic(  params,data)

nData = length(data);
times = 1:nData;

totalSqrErr = 0;

for i=1:nData
   actual = data(i);
   predicted = funLogistic(params,times(i));
   err = (actual - predicted)^2;
   totalSqrErr = totalSqrErr + err;
end

rmsErr = sqrt(totalSqrErr);

end

