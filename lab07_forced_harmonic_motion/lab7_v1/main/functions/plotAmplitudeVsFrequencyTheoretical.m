function plotAmplitudeVsFrequencyTheoretical(frequencies_exp, amplitudes_exp)
    % Define parameters
    omega0 = mean(frequencies_exp(amplitudes_exp == max(amplitudes_exp)));  % Resonance frequency
    gamma_values = [0.5];  % Adjusted damping coefficient for best fit
    omega = linspace(min(frequencies_exp)*0.9, max(frequencies_exp)*1.1, 1000);  % Frequency range

    % Determine scaling factor
    F0_over_m = max(amplitudes_exp) * gamma_values(1) * omega0;
    
    % Initialize figure
    figure('Position', [100, 100, 800, 500]);
    hold on;

    % Plot amplitude
    gamma = gamma_values(1);
    A = F0_over_m ./ sqrt((omega0^2 - omega.^2).^2 + (gamma .* omega).^2);

    % Plot the curve
    plot(omega, A, 'b-', 'LineWidth', 1.5);

    % Overlay experimental data
    plot(frequencies_exp, amplitudes_exp, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 6);

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
