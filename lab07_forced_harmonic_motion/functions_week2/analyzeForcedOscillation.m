function [period, amplitude, phase_diff] = analyzeForcedOscillation(time, position, angle)
    %% Period Calculation
    % Detrend and center the position data
    position = detrend(position);  % Remove any linear trend
    pos_centered = position - mean(position);
    
    % Find peaks in the position data to calculate the period
    [~, locs_pos] = findpeaks(pos_centered, time);
    if length(locs_pos) > 1
        periods = diff(locs_pos);
        period = mean(periods);
    else
        warning('Not enough peaks found to calculate period.');
        period = NaN;
    end
    
    %% Amplitude Calculation: half the peak-to-peak range
    amplitude = (max(pos_centered) - min(pos_centered)) / 2;
    
    %% Phase Difference Calculation
    % Detrend and center the angle data
    angle = detrend(angle);
    angle_centered = angle - mean(angle);
    
    % Find peaks in the angle data
    [~, locs_angle] = findpeaks(angle_centered, time);
    
    % Ensure there are enough peaks to compare
    num_peaks = min(length(locs_pos), length(locs_angle));
    if num_peaks < 1
        warning('Not enough peaks found in position or angle data to calculate phase difference.');
        phase_diff = NaN;
        return;
    end
    
    % Compute time differences between corresponding peaks
    delta_t = locs_pos(1:num_peaks) - locs_angle(1:num_peaks);
    
    % Compute phase differences
    phase_diffs = 2 * pi * delta_t / period;
    
    % Average the phase differences
    phase_diff = mean(phase_diffs);
    
    % Wrap phase difference to [-pi, pi]
    phase_diff = mod(phase_diff + pi, 2*pi) - pi;
end