function [s, x] = discretize_state(x, statelist)
	x = repmat(x, size(statelist,1), 1);

	[~, s] = min(sqrt(sum((statelist-x).^2,2))); 

	x = [x(s,1), x(s,2), x(s,3), x(s,4), x(s,5)];
end