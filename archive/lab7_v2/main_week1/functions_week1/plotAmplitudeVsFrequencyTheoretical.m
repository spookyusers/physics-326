function plotAmplitudeVsFrequencyTheoretical(omega_exp, amplitudes_exp)
    % Define parameters
    [max_amp, idx_max_amp] = max(amplitudes_exp);
    omega0 = omega_exp(idx_max_amp);  % Resonance angular frequency
    gamma = 0.5;  % Adjusted damping coefficient for best fit
    omega = linspace(min(omega_exp)*0.9, max(omega_exp)*1.1, 1000);  % Angular frequency range

    % Determine scaling factor (F0/m)
    F0_over_m = max_amp * sqrt((omega0^2 - omega0^2)^2 + (gamma * omega0)^2);

    % Calculate theoretical amplitude
    A = F0_over_m ./ sqrt((omega0^2 - omega.^2).^2 + (gamma .* omega).^2);

    % Initialize figure
    figure('Position', [100, 100, 800, 500]);
    hold on;

    % Plot the theoretical amplitude
    plot(omega, A, 'b-', 'LineWidth', 1.5);

    % Overlay experimental data
    plot(omega_exp, amplitudes_exp, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 6);

    % Labels and title
    xlabel('Angular Frequency \omega (rad/s)', 'FontSize', 14);
    ylabel('Amplitude A (m)', 'FontSize', 14);
    title('Amplitude vs. Angular Frequency', 'FontSize', 16);

    % Legend
    legend({'Theoretical Amplitude', 'Experimental Data'}, 'Location', 'Best', 'FontSize', 12);

    % Grid and aesthetics
    grid on;
    ax = gca;
    ax.FontSize = 12;

    % Adjust axes limits
    xlim([min(omega), max(omega)]);
    ylim([0, max([max(A(:)), max(amplitudes_exp(:))]) * 1.1]);

    hold off;
end
