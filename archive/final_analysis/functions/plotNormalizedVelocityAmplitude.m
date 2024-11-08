function plotNormalizedVelocityAmplitude(data_case1, data_case2)
    % plotNormalizedVelocityAmplitude
    % Plots normalized velocity amplitude vs. normalized frequency for two damping cases.
    %
    % Inputs:
    %   data_case1 - Structure containing Frequency, Vmax, omega0 for case 1
    %   data_case2 - Structure containing Frequency, Vmax, omega0 for case 2

    % Calculate normalized frequencies
    omega_bar_case1 = data_case1.Frequency / data_case1.omega0;
    omega_bar_case2 = data_case2.Frequency / data_case2.omega0;

    % Normalize velocity amplitudes
    g_case1 = data_case1.Vmax / max(data_case1.Vmax);
    g_case2 = data_case2.Vmax / max(data_case2.Vmax);

    % Plotting
    figure;
    hold on;
    plot(omega_bar_case1, g_case1, 'o-', 'DisplayName', 'Damping Case 1');
    plot(omega_bar_case2, g_case2, 's-', 'DisplayName', 'Damping Case 2');
    xlabel('Normalized Frequency \omega / \omega_0', 'FontSize', 14);
    ylabel('Normalized Velocity Amplitude g(\omega)', 'FontSize', 14);
    title('Normalized Velocity Amplitude vs. Normalized Frequency', 'FontSize', 16);
    legend('Location', 'Best', 'FontSize', 12);
    grid on;
    hold off;
end
