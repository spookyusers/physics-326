function [period, amplitude, phase_diff] = analyzeForcedOscillation(time, position, angle)
    % analyzeForcedOscillation
    % Analyzes forced oscillation data to extract period, amplitude, and phase difference.
    %
    % Inputs:
    %   time     - Time vector (s)
    %   position - Position data (m)
    %   angle    - Angle data (degrees or radians)
    %
    % Outputs:
    %   period     - Period of oscillation (s)
    %   amplitude  - Amplitude of oscillation (m)
    %   phase_diff - Phase difference between position and angle (rad)
    
    %% Preprocessing
    % Detrend and center the position data
    position = detrend(position);
    pos_centered = position - mean(position);

    % Detrend and center the angle data
    angle = detrend(angle);
    angle_centered = angle - mean(angle);

    % Ensure angle data is in radians
    if max(abs(angle_centered)) > pi
        angle_centered = deg2rad(angle_centered);
    end

    %% Period Calculation
    % Find peaks in the position data to calculate the period
    [~, locs_pos] = findpeaks(pos_centered, time);
    if length(locs_pos) > 1
        periods = diff(locs_pos);
        period = mean(periods);
    else
        warning('Not enough peaks found to calculate period.');
        period = NaN;
    end

    %% Amplitude Calculation
    % Amplitude is half the peak-to-peak range
    amplitude = (max(pos_centered) - min(pos_centered)) / 2;

    %% Phase Difference Calculation
    % Interpolate signals to a common time vector
    common_time = linspace(min(time), max(time), length(time));
    pos_interp = interp1(time, pos_centered, common_time);
    angle_interp = interp1(time, angle_centered, common_time);

    % Compute cross-correlation (swap order to get correct lag sign)
    [cross_corr, lags] = xcorr(angle_interp, pos_interp, 'coeff');
    [~, max_idx] = max(cross_corr);
    lag = lags(max_idx);

    % Calculate phase difference
    dt = mean(diff(common_time));  % Time step
    time_lag = lag * dt;
    phase_diff = 2 * pi * time_lag / period;  % Positive sign

    % Wrap phase difference to [-pi, pi]
    phase_diff = mod(phase_diff + pi, 2*pi) - pi;
end
