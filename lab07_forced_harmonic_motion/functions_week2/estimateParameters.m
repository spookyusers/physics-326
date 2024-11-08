function [omega0_est, gamma_est] = estimateParameters(frequencies, amplitudes)
    % Remove NaN values if any
    valid_indices = ~isnan(frequencies) & ~isnan(amplitudes);
    frequencies = frequencies(valid_indices);
    amplitudes = amplitudes(valid_indices);
    
    % Define the theoretical amplitude function
    amplitudeModel = @(params, omega) params(1) ./ sqrt((params(2)^2 - omega.^2).^2 + (2 * params(3) .* omega).^2);
    
    % Initial guesses for [F0_over_m, omega0, gamma]
    [~, max_idx] = max(amplitudes);
    initial_omega0 = frequencies(max_idx); 
    initial_gamma = 0.1;                   
    initial_F0_over_m = max(amplitudes) * initial_gamma * initial_omega0;
    
    initialGuess = [initial_F0_over_m, initial_omega0, initial_gamma];
    
    % Set options for lsqcurvefit
    options = optimset('Display', 'off');
    
    % Perform curve fitting
    params_estimated = lsqcurvefit(amplitudeModel, initialGuess, frequencies, amplitudes, [], [], options);
    
    % Extract estimated parameters
    omega0_est = params_estimated(2);
    gamma_est = params_estimated(3);
end
