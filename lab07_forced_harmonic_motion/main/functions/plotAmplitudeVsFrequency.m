function plotAmplitudeVsFrequency(frequencies, amplitudes)
    % Sort the data
    [frequencies_sorted, idx] = sort(frequencies);
    amplitudes_sorted = amplitudes(idx);

    % Create the figure
    figure('Position', [100, 100, 800, 500]);

    % Plot the data
    plot(frequencies_sorted, amplitudes_sorted, 's-', 'Color', [0.8500 0.3250 0.0980], ...
        'LineWidth', 1.5, 'MarkerSize', 6, 'MarkerFaceColor', [0.8500 0.3250 0.0980]);

    % Title and axis labels
    title('Amplitude vs. Angular Frequency', 'FontSize', 16);
    xlabel('Angular Frequency \omega (rad/s)', 'FontSize', 14);
    ylabel('Amplitude A (m)', 'FontSize', 14);

    % Adjust axes limits
    xlim([min(frequencies_sorted)*0.95, max(frequencies_sorted)*1.05]);
    ylim([0, max(amplitudes_sorted)*1.1]);

    % Customize grid lines
    grid on;
    ax = gca;
    ax.GridLineStyle = '--';
    ax.GridAlpha = 0.3;
    ax.FontSize = 12;
end
