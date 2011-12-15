function [Q, E] = update_sarsa_lambda(s, a, r, sp, ap, Q, E, alpha, ...
	gamma, lambda)

	E = (gamma*lambda) * E;

	E(s,a) = 1;

	td = r + (gamma *Q(sp,ap)) - Q(s,a);

	Q = Q + (alpha*td) .* E;

end