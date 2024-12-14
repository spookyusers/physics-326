function x = logistic(x0, a, n)
    % Input parameters:
    % x0: initial value (between 0 and 1)
    % a: growth parameter
    % n: number of iterations

    % Initialize array to store values
    x = zeros(n+1, 1);
    x(1) = x0;

    % Calculate iterations
    for i = 1:n
        x(i+1) = a * x(i) * (1 - x(i));
    end
end