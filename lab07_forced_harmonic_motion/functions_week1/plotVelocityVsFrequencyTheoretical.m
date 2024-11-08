function plotVelocityVsFrequencyTheoretical(omega_exp, v_max_exp)
    % Define parameters
    [max_vmax, idx_max_vmax] = max(v_max_exp);
    omega0 = omega_exp(idx_max_vmax);  % Resonance angular frequency
    gamma = 0.5;  % Consistent damping coefficient
    omega = linspace(min(omega_exp)*0.9, max(omega_exp)*1.1, 1000);  % Angular frequency range

    % Determine F0_over_m
    F0_over_m = max_vmax * sqrt((omega0^2 - omega0^2)^2 + (gamma * omega0)^2) / (gamma * omega0);

    % Calculate theoretical maximum velocity
    v_max = F0_over_m * (gamma .* omega) ./ sqrt((omega0^2 - omega.^2).^2 + (gamma .* omega).^2);

    % Initialize figure
    figure('Position', [100, 100, 800, 500]);
    hold on;

    % Plot the theoretical maximum velocity
    plot(omega, v_max, 'b-', 'LineWidth', 1.5);

    % Overlay experimental data
    plot(omega_exp, v_max_exp, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 6);

    % Labels and title
    xlabel('Angular Frequency \omega (rad/s)', 'FontSize', 14);
    ylabel('Maximum Velocity v_{max} (m/s)', 'FontSize', 14);
    title('Maximum Velocity vs. Angular Frequency', 'FontSize', 16);

    % Legend
    legend({'Theoretical Maximum Velocity', 'Experimental Data'}, 'Location', 'Best', 'FontSize', 12);

    % Grid and aesthetics
    grid on;
    ax = gca;
    ax.FontSize = 12;

    % Adjust axes limits
    xlim([min(omega), max(omega)]);
    ylim([0, max([max(v_max(:)), max(v_max_exp(:))]) * 1.1]);

    hold off;
end
