function [action] = next_action(Q, state, epsilon)

	numactions = size(Q,2); % # of possible action

	if (rand() > epsilon)
		action = best_action(Q, state);
	else
		action = randi(numactions,1);
	end;
end