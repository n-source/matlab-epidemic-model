function output = fitModel( func,errFunc ,data, initialGuess0 )

nData = length(data);
day = 1:nData;

fprintf('Initial guess for K, r and A : %6f %6f %6f\n', initialGuess0(1),initialGuess0(2),initialGuess0(3) );
fprintf('Acquiring a better guess using non matlab`s  inbuilt non linear fit function\n');
%% Acquire a better initial guess from Matlab's inbuilt non linear regression model fit
mdl = fitnlm(day,data,func, initialGuess0);
initialGuess = mdl.Coefficients.Estimate;
initialGuess = initialGuess'; % converting to a row vector
fprintf('New guess for K, r and A : %6f %6f %6f\n', initialGuess(1),initialGuess(2),initialGuess(3) );

%% Problem Definiton | Finding the regression parameters using Particle Swarm Optimization algorithm
problem.CostFunction = errFunc;  % Cost Function
problem.nVar = 3;       % Number of Unknown (Decision) Variables
problem.VarMin =  [0 0 0];  % Lower Bound of Decision Variables
problem.VarMax =  [100000 10 30000];   % Upper Bound of Decision Variables
problem.initialGuess = initialGuess;

%% Parameters of PSO
params.MaxIt = 500;        % Maximum Number of Iterations
params.nPop = 10;           % Population Size (Swarm Size)
params.w = 1;               % Intertia Coefficient
params.wdamp = 0.99;        % Damping Ratio of Inertia Coefficient
params.c1 = 2;              % Personal Acceleration Coefficient
params.c2 = 2;              % Social Acceleration Coefficient
params.ShowIterInfo = true; % Flag for Showing Iteration Informatin
fprintf('Starting PSO Algorithm with population %6f and Max iteration %6f \n',params.nPop,params.MaxIt );
%% Calling PSO

out = PSO(problem, params,data);

output = out.BestSol.Position;

end

