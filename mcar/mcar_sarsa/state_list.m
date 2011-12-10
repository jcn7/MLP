function [statelst] = build_state_list()


	% x position
	x = linspace(-1.2, .5, 10);
	x_dot = linspace(-0.07, 0.07, 10);

	statelst = [];
	index = 1;

	% there is probably a better a faster way to do this
	% but this is not called often 
	for i = 1:length(x)
		for j = 1:length(x_dot)
			statelst(index,1) = x(i);
			statelst(index,2) = x_dot(j);
			index = index+1;
		end;
	end;
end