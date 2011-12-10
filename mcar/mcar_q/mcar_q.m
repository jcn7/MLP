function [data, w] = mcar_q(maxepi, graphic)

global grafica;

[numaction, actionMap] = bicycle_actions();

gamma = 1;  % the discount
alpha = .01;   % learning rate
epsilon = 0;
order = 5;
n = (order+1)^2;         % number of features
grafica = graphic;

w = zeros(numaction, n);
data = zeros(maxepi, 1);

for epi = 1:maxepi
    % initial state
    [state, ~, endsim] = mcar_graphics_simulator();   
    steps = 0;
    action = randi(3,1); % initial action is random
    
    % one episode
    while ~endsim
        [sprime, reward, endsim] = mcar_graphics_simulator(state, actionMap(action));
        features = computeFeatures(state, order);
        
        % compute temporal difference error
        tde = reward - sum(w(action,:) .* features);
        
        newf = computeFeatures(sprime, order);
        if ~endsim
            % find max Q(s_t+1, a)
            q_t1 = zeros(numaction, 1);            
            for a = 1:numaction
                q_t1(a) = sum(w(a,:).*newf);
            end;
            
            [bestQ, bestAction] = max(q_t1);
            tde = tde + gamma * bestQ;
        end;
        
        %update weights
        w(action, :) = w(action, :) + alpha*tde*features;
        
        if rand() < epsilon
            action = randi(3,1);
        else
            action = bestAction;
        end;
        state = sprime;
        steps = steps + 1;
    end;    
    data(epi) = steps;
    toPrint = strcat('episode: ', int2str(epi), ' steps: ', int2str(steps), '\n');  
    fprintf(toPrint);
    plot(data);
end;
end

