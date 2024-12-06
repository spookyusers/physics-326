function x_values = logistic_sequence(x0, a, n)
    % Generates n iterations of the logistic map
    % x0: initial value (between 0 and 1)
    % a: growth parameter (between 0 and 4)
    % n: number of iterations
    % Returns: array of n+1 values (including initial value)
    
    x_values = zeros(n+1, 1);  % Preallocate array for efficiency
    x_values(1) = x0;          % Set initial value
    
    for i = 1:n
        x_values(i+1) = logistic_step(x_values(i), a);
    end
end