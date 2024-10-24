% -----------------------------------------------------------------
% Function to calculate period, phase difference, and display results
% -----------------------------------------------------------------
function [average_period, sigmaT, delta_phi, sigmaA] = periodPhase(crossing_times, weights, label)
    % Extracting integer indices from zero crossings
    n_crossings = length(crossing_times);
    crossing_indices = (0:n_crossings-1)'; % Integer labels for crossings

    % Input data for linear fit function
    x = crossing_indices;
    y = crossing_times;
    w = ones(length(x), 1) * weights;

    % Generalized linear least squares fit
    % Reshape the arrays into column vectors
    x = x(:);
    y = y(:);
    w = w(:);

    % Computes determinant of matrix involved in the normal equations of the
    % weighted least-squares method.
    Delta = sum(w) * sum(w .* (x .^ 2)) - (sum(w .* x) .^ 2);

    % Perform the least-squares fit calculations for A (intercept) and B (slope)
    A = (sum(w .* (x .^ 2)) * sum(w .* y) - sum(w .* x) * sum(w .* x .* y)) / Delta;
    B = (sum(w) * sum(w .* x .* y) - sum(w .* x) * sum(w .* y)) / Delta;

    % Calculate uncertainties (standard errors) for A and B
    sigmaA = sqrt(sum(w .* (x .^ 2)) / Delta);
    sigmaB = sqrt(sum(w) / Delta);

    % Calculate period of oscillation
    average_period = 2 * B;  % The slope (B) represents half the period, so multiply by 2
    sigmaT = 2 * sigmaB; % The error propagates through the calculation

    % Calculate phase difference (delta_phi) in radians
    delta_phi = (A / average_period) * 2 * pi;

    % Display results
    fprintf('----------------------------------------------------------\n')
    disp(['Average Period (' label '): ', num2str(average_period), ' seconds']);
    disp(['Uncertainty in Period (' label '): ', num2str(sigmaT), ' seconds']);
    disp(['Phase Difference (delta_phi) (' label '): ', num2str(delta_phi), ' radians']);
    disp(['Uncertainty in Phase (sigmaA) (' label '): ', num2str(sigmaA), ' radians']);
    fprintf('----------------------------------------------------------\n')
end

