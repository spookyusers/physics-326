% Task 3: Examine behavior near first period doubling

% Parameters
a_values = [2.99, 3.01];
x0_values = [0.667, 0.5];
n_iterations = 1000;  % Using more iterations to see steady state
start_plot = 975;     % Only plot last 100 points to see steady state clearly

% Create figure with subplots
figure('Position', [100, 100, 1000, 800]);

% Store results
final_values = zeros(length(a_values), length(x0_values));

% Loop through each a value
for i = 1:length(a_values)
    for j = 1:length(x0_values)
        subplot(2, 2, (i-1)*2 + j)
        
        % Calculate trajectory
        x = logistic(x0_values(j), a_values(i), n_iterations);
        
        % Plot only the last portion to see steady state
        plot(start_plot:n_iterations, x(start_plot+1:end), 'o-')
        
        % Store final values
        final_values(i,j) = x(end);
        
        title(sprintf('a = %.2f, x0 = %.3f', a_values(i), x0_values(j)))
        xlabel('n')
        ylabel('x(n)')
        grid on
        ylim([0 1])  % Set consistent y-axis limits
    end
end

% Print analysis results
for i = 1:length(a_values)
    fprintf('\nFor a = %.2f:\n', a_values(i))
    fprintf('Final values for x0 = %.3f: %.6f\n', x0_values(1), final_values(i,1))
    fprintf('Final values for x0 = %.3f: %.6f\n', x0_values(2), final_values(i,2))
end