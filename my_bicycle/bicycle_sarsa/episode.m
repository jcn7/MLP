function [total_r, steps, Q] = episode(maxsteps, Q, E, alpha, gamma, ...
    lambda, epsilon, statelst, actions)

	[full_s, r, endsim] = bicycle_simulator;

	steps = 0;
	total_r = 0;

	s = discretize_state(full_s(1:5), statelst);

	action = next_action(Q,s,epsilon);

	E = 0.*E;

	% trace the x and y positions through out the episode, for ploting
	xpos = []; 
	ypos = [];

	while (~endsim | steps < maxsteps)
		t = actions(action, 1);
		d = actions(action, 2);

		xpos(steps+1) = full_s(10);
		ypos(steps+1) = full_s(11);

		[new_full_s, r, endsim] = bicycle_simulator(full_s, action);

		[sip, sp] = discretize_state(new_full_s(1:5), statelst);
		actionp = next_action(Q,sip,epsilon)

		[Q,E] = update_sarsa_lambda(s, action, r, sip, actionp, Q, E, alpha, gamma, lambda);

		full_s = new_full_s;
		action = actionp;
		s = sip;

		steps = steps + 1;

		% draw the trejectory of the bike, to be moved into seperate function
		% maybe be more fancy with the ploting.
		line(xpos, ypos);
		title('trajectory');
		drawnow
	end;
end