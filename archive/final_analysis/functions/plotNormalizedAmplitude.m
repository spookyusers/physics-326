function plotNormalizedAmplitude(data_case1, data_case2)
    % plotNormalizedAmplitude
    % Plots normalized amplitude vs. normalized frequency for two damping cases.
    %
    % Inputs:
    %   data_case1 - Structure containing Frequency, Amplitude, omega0 for case 1
    %   data_case2 - Structure containing Frequency, Amplitude, omega0 for case 2
    
    % Calculate normalized frequencies and amplitudes for case 1
    omega_bar_case1 = data_case1.Frequency / data_case1.omega0;
    r_case1 = data_case1.Amplitude / max(data_case1.Amplitude);

    % Calculate normalized frequencies and amplitudes for case 2
    omega_bar_case2 = data_case2.Frequency / data_case2.omega0;
    r_case2 = data_case2.Amplitude / max(data_case2.Amplitude);

    % Plotting
    figure;
    hold on;
    plot(omega_bar_case1, r_case1, 'o-', 'DisplayName', 'Damping Case 1');
    plot(omega_bar_case2, r_case2, 's-', 'DisplayName', 'Damping Case 2');
    xlabel('Normalized Frequency \omega / \omega_0');
    ylabel('Normalized Amplitude r(\omega)');
    title('Normalized Amplitude vs. Normalized Frequency');
    legend('Location', 'Best');
    grid on;
    hold off;
end