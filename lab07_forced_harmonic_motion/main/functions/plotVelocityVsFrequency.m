% plotVelocityVsFrequency.m
%
% Plots the maximum velocity versus the angular frequency and marks the resonance frequency.
%
% Inputs:
%   frequencies - Array of angular frequencies (in rad/s)
%   v_max       - Array of maximum velocities (in m/s)

function plotVelocityVsFrequency(frequencies, v_max)
    figure('Position', [100, 100, 800, 500]);
    plot(frequencies, v_max, 'o-r', 'MarkerSize', 8);
    title('Maximum Velocity vs Angular Frequency (Large Damping Disc)', 'FontSize', 14);
    xlabel('Angular Frequency \omega (rad/s)', 'FontSize', 12);
    ylabel('Maximum Velocity v_{max} (m/s)', 'FontSize', 12);
    grid on;

    % Find peak and calculate 0.707 level
    [peak_v_max, peak_idx] = max(v_max);
    omega_0 = frequencies(peak_idx);
    v_707 = 0.707 * peak_v_max;

    hold on;
    plot(omega_0, peak_v_max, 'k*', 'MarkerSize', 12);
    text(omega_0, peak_v_max*1.05, sprintf('\\omega_0 = %.2f rad/s', omega_0));

    % Find frequencies where v_max crosses 0.707 v_max
    idx_above = find(v_max >= v_707);
    omega_band = frequencies(idx_above);
    bandwidth = omega_band(end) - omega_band(1);

    % Add 0.707 line and bandwidth annotation
    plot([min(frequencies), max(frequencies)], [v_707, v_707], 'k--');
    text(min(frequencies), v_707*1.05, '0.707 v_{max}');
    text(min(frequencies), v_707*0.95, sprintf('Bandwidth = %.2f rad/s', bandwidth));

    xlim([min(frequencies)*0.9, max(frequencies)*1.1]);
    ylim([0, max(v_max)*1.1]);
end
