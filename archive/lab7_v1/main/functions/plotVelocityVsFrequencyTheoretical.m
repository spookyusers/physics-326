function plotVelocityVsFrequencyTheoretical(frequencies_exp, v_max_exp)
    % Define parameters
    omega0 = mean(frequencies_exp(v_max_exp == max(v_max_exp)));  % Resonance frequency from experimental data
    gamma_values = [0.7];  % Adjusted damping coefficient for best fit
    omega = linspace(min(frequencies_exp)*0.9, max(frequencies_exp)*1.1, 1000);  % Frequency range

    % Determine scaling factor
    F0_over_m = max(v_max_exp) * sqrt((omega0^2 - omega0^2)^2 + (gamma_values(1) * omega0)^2) / (gamma_values(1) * omega0);
    if isempty(F0_over_m) || isnan(F0_over_m)
        F0_over_m = max(v_max_exp);
    end

    % Initialize figure
    figure('Position', [100, 100, 800, 500]);
    hold on;

    % Plot maximum velocity
    gamma = gamma_values(1);
    v_max = F0_over_m * (gamma .* omega) ./ sqrt((omega0^2 - omega.^2).^2 + (gamma .* omega).^2);

    % Plot the theoretical curve
    plot(omega, v_max, 'b-', 'LineWidth', 1.5);

    % Overlay experimental data
    plot(frequencies_exp, v_max_exp, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 6);

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
