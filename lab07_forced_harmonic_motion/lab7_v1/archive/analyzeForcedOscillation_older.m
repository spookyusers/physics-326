% analyzeForcedOscillation.m
%
% Analyzes oscillation data to extract key parameters.
%
% Inputs:
%   time     - Vector of time points
%   position - Vector of position measurements of the oscillating mass
%   angle    - Vector of angle measurements from the driving force
%
% Outputs:
%   period     - Average period of oscillation (seconds)
%   amplitude  - Amplitude of position oscillation (meters)
%   phase_diff - Phase difference between position and angle (radians)

function [period, amplitude, phase_diff] = analyzeForcedOscillation(time, position, angle)
    %% Period Calculation
    % Center the position data around zero by subtracting the mean
    pos_centered = position - mean(position);

    % Find zero crossings from positive to negative
    pos_crossings = pos_centered(1:end-1) >= 0 & pos_centered(2:end) < 0;

    % Get the times when these crossings occur
    zero_crossing_times = time(pos_crossings);

    % Calculate periods by taking differences between every other crossing
    periods = diff(zero_crossing_times(1:2:end));

    % Average all periods to get mean period
    period = mean(periods);

    %% Amplitude Calculation
    % Calculate amplitude as half the peak-to-peak distance
    amplitude = (max(position) - min(position)) / 2;

    %% Phase Difference Calculation
    % Find peaks in both position and angle signals
    min_peak_dist = round(length(time) / 20);
    [~, pos_peak_locs] = findpeaks(position, 'MinPeakDistance', min_peak_dist);
    [~, angle_peak_locs] = findpeaks(angle, 'MinPeakDistance', min_peak_dist);

    % Determine how many peaks to use for phase calculation
    num_peaks = min(5, min(length(pos_peak_locs), length(angle_peak_locs)));

    % Initialize array to store phase differences
    phase_diffs = zeros(num_peaks - 1, 1);

    % Calculate phase differences for each pair of peaks
    for i = 1:num_peaks - 1
        % Find time difference between corresponding peaks
        time_diff = time(pos_peak_locs(i)) - time(angle_peak_locs(i));

        % Convert time difference to phase difference
        phase_diffs(i) = 2 * pi * (time_diff / period);

        % Wrap phase to interval [-pi, pi]
        while phase_diffs(i) > pi
            phase_diffs(i) = phase_diffs(i) - 2 * pi;
        end
        while phase_diffs(i) < -pi
            phase_diffs(i) = phase_diffs(i) + 2 * pi;
        end
    end

    % Average all phase differences to get final result
    phase_diff = mean(phase_diffs);
end
