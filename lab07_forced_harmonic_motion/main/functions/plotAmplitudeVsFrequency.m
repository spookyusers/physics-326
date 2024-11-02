% plotAmplitudeVsFrequency.m
%
% Plots the amplitude of oscillation versus the angular frequency.
%
% Inputs:
%   frequencies - Array of angular frequencies (in rad/s)
%   amplitudes  - Array of amplitudes (in meters)

function plotAmplitudeVsFrequency(frequencies, amplitudes)
    figure('Position', [100, 100, 800, 500]);
    plot(frequencies, amplitudes, 'bo-', 'LineWidth', 1.5, 'MarkerSize', 8);
    title('Amplitude vs Angular Frequency (Large Damping Disc)', 'FontSize', 14);
    xlabel('Angular Frequency \omega (rad/s)', 'FontSize', 12);
    ylabel('Amplitude A (m)', 'FontSize', 12);
    grid on;
    xlim([0, max(frequencies)*1.1]);
    ylim([0, max(amplitudes)*1.1]);
end
