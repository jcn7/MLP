% next_action.m
%
% Choose the next action based on the best action given Q and a state
%

function [action] = next_action(Q, state, epsilon)

	numactions = size(Q,2); % # of possible action

	if (rand() > epsilon)
		action = best_action(Q, state);
	else
		action = randi(numactions,1);
	end;
end