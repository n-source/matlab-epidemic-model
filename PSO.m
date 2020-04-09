
function out = PSO(problem, psoParams,data)
    costFunction = problem.CostFunction;  
    nParams = problem.nParams;        

    paramSize = [1 nParams];        

    paramLowerLimit = problem.paramLowerLimit;	
    paramHigherLimit = problem.paramHigherLimit;    
    
    initialGuess = problem.initialGuess;

    %% Parameters of the Particle Swarm Optimization Algorithm

    maxIteration = psoParams.maxIteration;   % Maximum Number of Iterations

    nParticles = psoParams.nParticles;     % Population Size (Swarm Size)

    w = psoParams.w;           % Intertia Coefficient
    wDamping = psoParams.wdamp;   % Damping Ratio of Inertia Coefficient
    c1 = psoParams.c1;         % Personal Acceleration Coefficient
    c2 = psoParams.c2;         % Social Acceleration Coefficient

    MaxVelocity = 0.2*(paramHigherLimit-paramLowerLimit);
    MinVelocity = -MaxVelocity;
    
    %% Initialization

    % Structure of a particle
    emptyParticle.Position = [];
    emptyParticle.Velocity = [];
    emptyParticle.Cost = [];
    emptyParticle.Best.Position = [];
    emptyParticle.Best.Cost = [];

    % Create population matrix
    particle = repmat(emptyParticle, nParticles, 1);

    % Initialize global best
    globalBest.Cost = inf;

    % Initialize random population spread out in the search area
    for i=1:nParticles

        % Generate random solutions
        
        if i==1
            
            particle(i).Position = initialGuess; % set position of particle 1 as initial guess
        else
            particle(i).Position = unifrnd(paramLowerLimit, paramHigherLimit, paramSize); % randomly generate solutions for other particles
        end
        % Initialize velocity
        particle(i).Velocity = zeros(paramSize);

        % Evaluate the costs
        particle(i).Cost = costFunction(particle(i).Position,data);

        % Update personal best
        particle(i).Best.Position = particle(i).Position;
        particle(i).Best.Cost = particle(i).Cost;

        % Update global best
        if particle(i).Best.Cost < globalBest.Cost
            globalBest = particle(i).Best;
        end

    end

    % Best costs with iteration are held here
    bestCosts = zeros(maxIteration, 1);


    %% Loop till Max Iteration is reached

    for it=1:maxIteration

        for i=1:nParticles

            % Update Velocity
            particle(i).Velocity = w*particle(i).Velocity   + c1*rand(paramSize).*(particle(i).Best.Position - particle(i).Position) + c2*rand(paramSize).*(globalBest.Position - particle(i).Position);

            % Apply Lower and Upper bounds of the velocity
            particle(i).Velocity = max(particle(i).Velocity, MinVelocity);
            particle(i).Velocity = min(particle(i).Velocity, MaxVelocity);
            
            % Update Position
            particle(i).Position = particle(i).Position + particle(i).Velocity;
            
            % Apply Lower and Upper Bounds of the position
            particle(i).Position = max(particle(i).Position, paramLowerLimit);
            particle(i).Position = min(particle(i).Position, paramHigherLimit);

            % Finding the cost
            particle(i).Cost = costFunction(particle(i).Position,data);

            % Update Personal Best
            if particle(i).Cost < particle(i).Best.Cost

                particle(i).Best.Position = particle(i).Position;
                particle(i).Best.Cost = particle(i).Cost;

                % Update Global Best
                if particle(i).Best.Cost < globalBest.Cost
                    globalBest = particle(i).Best;
                end            

            end

        end

        bestCosts(it) = globalBest.Cost;
     
        % Damping inertia
        w = w * wDamping;

    end
  
    out.pop = particle;
    out.BestSol = globalBest;
    out.BestCosts = bestCosts;
    
end