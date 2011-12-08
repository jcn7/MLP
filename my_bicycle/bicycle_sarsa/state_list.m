function [statelst] = build_state_list()

	% angle from vertical to bicycle (radians)
	w = [-1/15*pi, -.15, -0.06, 0, 0.06, 0.15, 1/15*pi];
	% angular velocity (radians/second)
	w_dot = [-2, -.5, -.25, 0, .25, .5, 2];
	% angular acceleration (radians/second^2)
	w_dot_dot = [-4, -2, 0, 2, 4];

	% angle of the handle bars are displaced from normal (radians)
	theta = [-pi/2, -1, -.2, 0, .2, 1, pi/2];
	% angular velocity of the angle
	theta_dot = [-4, -2, 0, 2, 4];

	statelst = [];
	index = 1;

	% there is probably a better a faster way to do this
	% but this is not called often 
	for i = 1:length(w)
		for j = 1:length(w_dot)
			for k = 1:length(w_dot_dot)
				for l = 1:length(theta)
					for m = 1:length(theta_dot)
						statelst(index,1) = w(i);
						statelst(index,2) = w_dot(j);
						statelst(index,3) = w_dot_dot(k);
						statelst(index,4) = theta(l);
						statelst(index,5) = theta_dot(m);
						index = index+1;
					end;
				end;
			end;
		end;
	end;
end