function [action] = best_action(Q, s)
	
	[~, action] = max(Q(s,:));
end