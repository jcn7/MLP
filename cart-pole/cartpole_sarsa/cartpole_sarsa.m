function lcurve = cartpole_sarsa(maxEpi)
    global grafica;

	gamma = 1;
	alpha = .3;
    epsilon = .001;
    lambda = 0.95;

    maxsteps = 2000;
    statelist = state_list();
    [numactions, actions] = cartpole_actions();

    grafica = false;

    nstates = size(statelist,1);
    nactions = numactions;

    Q = zeros(nstates, nactions);
    E = zeros(nstates, nactions);  %Eligibility matrix

    lcurve = zeros(maxEpi,1);

    for i=1:maxEpi
    	[tr, steps, Q] = episode(maxsteps, Q, E, alpha, gamma, ...
    		lambda, epsilon, statelist, actions);

    	epsilon = epsilon * .99; %decay exploration parameter

    	lcurve(i) = steps;
    end;

     figure;
     plot(lcurve);
     xlabel('Episodes');
     ylabel('Steps');
     title('learning curve plot');
end