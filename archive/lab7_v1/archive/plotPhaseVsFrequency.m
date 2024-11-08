% plotPhaseVsFrequency.m
%
% Plots the phase difference versus the angular frequency with improved aesthetics.
%
% Inputs:
%   frequencies - Array of angular frequencies (in rad/s)
%   phases      - Array of phase differences (in radians)

function plotPhaseVsFrequency(frequencies, phases)
    % Sort the data by frequency for a smooth plot
    [frequencies_sorted, idx] = sort(frequencies);
    phases_sorted = phases(idx);

    % Unwrap the phase differences for smoothness
    phases_unwrapped = unwrap(phases_sorted);

    % Create the figure
    figure('Position', [100, 100, 800, 500]);

    % Plot the phase difference vs. frequency
    plot(frequencies_sorted, phases_unwrapped, 'o-', 'Color', [0 0.4470 0.7410], ...
        'LineWidth', 1.5, 'MarkerSize', 6, 'MarkerFaceColor', [0 0.4470 0.7410]);

    % Title and axis labels with increased font size and units
    title('Phase Difference vs. Angular Frequency', 'FontSize', 16);
    xlabel('Angular Frequency \omega (rad/s)', 'FontSize', 14);
    ylabel('Phase Difference \phi (rad)', 'FontSize', 14);

    % Adjust axes limits
    xlim([min(frequencies_sorted)*0.95, max(frequencies_sorted)*1.05]);
    ylim([-3.5, 0]);  % Y-axis limited from -3.5 to 0 radians

    % Customize grid lines
    grid on;
    ax = gca;
    ax.GridLineStyle = '--';
    ax.GridAlpha = 0.3;  % Lighter grid lines

    % Adjust font sizes for tick labels
    ax.FontSize = 12;

    % Add horizontal reference lines at 0, -π/2, and -π
    hold on;
    yline(0, '--', 'LineWidth', 1, 'Color', [0.5 0.5 0.5]);
    yline(-pi/2, '--', 'LineWidth', 1, 'Color', [0.5 0.5 0.5]);
    yline(-pi, '--', 'LineWidth', 1, 'Color', [0.5 0.5 0.5]);

    % Remove legend if not necessary, or adjust it
    % legend('\phi vs \omega', 'Location', 'Best', 'FontSize', 12);

    % Optional: Adjust the position of the legend
    % legend('Phase Difference', 'Location', 'northeast');

    % Adjust title to sentence case
    % title('Phase difference vs. angular frequency', 'FontSize', 16);

    % Optionally, save the figure with higher resolution
    % saveas(gcf, 'PhaseVsFrequency.png');
end
