function [lcurve, w] = bicycle_q(maxepi)

[actionIndex, actionMap] = bicycle_actions();
gamma = .95;  % the discount
alpha = .01;   % learning rate
epsilon = .05;
numaction = length(actionMap); % number of possible actions
order = 5;
n = (order+1)^2;         % number of features

w = zeros(numaction, n);
lcurve = zeros(maxepi, 1);

for epi = 1:maxepi
    % initial state
    [state, ~, endsim] = bicycle_simulator();   
    steps = 0;
    action = randi(3,1); % initial action is random
    
    xpos = [];
    ypos = [];

    % one episode
    while ~endsim
        [sprime, reward, endsim] = bicycle_simulator(state, action);
        features = computeFeatures(state, order);
        xpos(steps+1) = sprime(10);
        ypos(steps+1) = sprime(11);
        
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
    lcurve(epi) = steps;
    toPrint = strcat('episode: ', int2str(epi), ' steps: ', int2str(steps), '\n');  
    fprintf(toPrint);


    % draw the trejectory of the bike, to be moved into seperate function
	% maybe be more fancy with the ploting.
	%line(xpos, ypos);
	%title('trajectory');
	%drawnow

    bicycle_draw_trajectory(xpos, ypos);
    
    %plot(lcurve);
end;

end