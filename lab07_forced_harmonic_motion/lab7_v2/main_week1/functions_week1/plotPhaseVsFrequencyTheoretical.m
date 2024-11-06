function plotPhaseVsFrequencyTheoretical(frequencies_exp, phases_exp)
    % Define parameters
    omega0 = 5.1441; % from experimental data w highest amplitude
    gamma = .7;  % Adjusted damping coefficient for best fit
    omega = linspace(min(frequencies_exp)*0.9, max(frequencies_exp)*1.1, 1000);  % Frequency range

    % Calculate theoretical phase shift
    phi = atan2(-gamma .* omega, omega0^2 - omega.^2);

    % Initialize figure
    figure('Position', [100, 100, 800, 500]);
    hold on;

    % Plot theoretical phase shift
    plot(omega, phi, 'b-', 'LineWidth', 1.5);

    % Overlay experimental data
    plot(frequencies_exp, phases_exp, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 6);

    % Labels and title
    xlabel('Angular Frequency omega (rad/s)', 'FontSize', 14);
    ylabel('Phase Difference phi (rad)', 'FontSize', 14);
    title('Phase Difference vs. Angular Frequency', 'FontSize', 16);

    % Legend
    legend({'Theoretical Phase Shift', 'Experimental Data'}, 'Location', 'Best', 'FontSize', 12);

    % Grid and aesthetics
    grid on;
    ax = gca;
    ax.FontSize = 12;

    % Adjust axes limits
    xlim([min(omega), max(omega)]);
    ylim([-pi, 0]);

    hold off;
end
