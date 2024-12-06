function next_x = logistic_step(x,a)
	% Computes one iteration of the logistic map
	% x: current value (between 0 and 1)
	% a: growth parameter (between 0 and 4)
	next_x = a * x * (1 - x);
end

