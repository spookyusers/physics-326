function plotVelocityVsFrequency(frequencies, v_max)
    % Sort the data
    [frequencies_sorted, idx] = sort(frequencies);
    v_max_sorted = v_max(idx);

    % Create the figure
    figure('Position', [100, 100, 800, 500]);

    % Plot the data
    plot(frequencies_sorted, v_max_sorted, '^-', 'Color', [0.9290 0.6940 0.1250], ...
        'LineWidth', 1.5, 'MarkerSize', 6, 'MarkerFaceColor', [0.9290 0.6940 0.1250]);

    % Title and axis labels
    title('Maximum Velocity vs. Angular Frequency', 'FontSize', 16);
    xlabel('Angular Frequency \omega (rad/s)', 'FontSize', 14);
    ylabel('Maximum Velocity v_{max} (m/s)', 'FontSize', 14);

    % Adjust axes limits
    xlim([min(frequencies_sorted)*0.95, max(frequencies_sorted)*1.05]);
    ylim([0, max(v_max_sorted)*1.1]);

    % Customize grid lines
    grid on;
    ax = gca;
    ax.GridLineStyle = '--';
    ax.GridAlpha = 0.3;
    ax.FontSize = 12;

    % Additional analysis (e.g., finding resonance frequency) can be included as before
end
