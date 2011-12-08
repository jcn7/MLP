function bicycle_sarsa(iter, maxEpi)

	gamma = 0.99;
	alpha = 0.5;
    epsilon = .01;
    lambda = 0.95;

    maxsteps = 1000;
    statelist = state_list();
    [numactions, actions] = bicycle_actions();

    nstates = size(statelist,1);
    nactions = numactions;

    Q = zeros(nstates, nactions);
    E = zeros(nstates, nactions);  %Eligibility matrix

    lcurve = zeros(maxEpi);

    for i=1:maxEpi
    	[tr, steps, Q] = episode(maxsteps, Q, E, alpha, gamma, ...
    		lambda, epsilon, statelist, actions);

    	epsilon = epsilon * .99; %decay exploration parameter

    	lcurve(i) = steps;
    end;

    plot(mean(lcurve));
    xlabel('Episodes');
    ylabel('Steps');
    title('learning curve plot');
end