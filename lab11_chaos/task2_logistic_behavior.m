% Task 2: Examine behavior for a < 3

% Parameters
a_values = [0.5, 1, 1.5, 2.9];
n_iterations = 20;  % First 20 values as specified
rng(42);           % Set random seed for reproducibility
n_initial = 3;     % Number of initial conditions

% Create random initial conditions between 0 and 1
x0_values = rand(1, n_initial);

% Create figure with subplots
figure('Position', [100, 100, 1000, 800]);

% Store results
final_values = zeros(length(a_values), n_initial);
iterations_to_converge = zeros(length(a_values), n_initial);
theoretical_fixed_points = zeros(length(a_values), 1);

% Loop through each a value
for i = 1:length(a_values)
    subplot(2, 2, i)
    hold on
    
    % Calculate theoretical fixed point
    if a_values(i) <= 1
        theoretical_fixed_points(i) = 0;
    else
        theoretical_fixed_points(i) = 1 - 1/a_values(i);
    end
    
    % Loop through each initial condition
    for j = 1:n_initial
        x = logistic(x0_values(j), a_values(i), n_iterations);
        plot(0:n_iterations, x, 'o-', 'DisplayName', ...
            sprintf('x0 = %.3f', x0_values(j)))
        
        % Store final value
        final_values(i,j) = x(end);
        
        % Find iterations to converge (when consecutive differences < 0.001)
        diffs = abs(diff(x));
        conv_idx = find(diffs < 0.001, 1);
        if ~isempty(conv_idx)
            iterations_to_converge(i,j) = conv_idx;
        else
            iterations_to_converge(i,j) = n_iterations;
        end
    end
    
    title(sprintf('a = %.1f', a_values(i)))
    xlabel('n')
    ylabel('x(n)')
    legend('Location', 'best')
    grid on
    hold off
end

% Print analysis results
for i = 1:length(a_values)
    fprintf('\nFor a = %.1f:\n', a_values(i))
    fprintf('Theoretical fixed point: %.4f\n', theoretical_fixed_points(i))
    fprintf('Final values: %.4f, %.4f, %.4f\n', final_values(i,:))
    fprintf('Iterations to converge: %d, %d, %d\n', iterations_to_converge(i,:))
end
