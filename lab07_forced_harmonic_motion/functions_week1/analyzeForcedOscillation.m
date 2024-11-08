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
    
    %% Amplitude Calculation
    % Amplitude is half the peak-to-peak range
    amplitude = (max(pos_centered) - min(pos_centered)) / 2;
    
    %% Phase Difference Calculation
    % Interpolate signals to a common time vector
    common_time = linspace(min(time), max(time), length(time));
    pos_interp = interp1(time, pos_centered, common_time);
    angle_interp = interp1(time, angle - mean(angle), common_time);
    
    % Convert angle to radians if necessary
    if max(abs(angle_interp)) > 2*pi
        angle_interp = deg2rad(angle_interp);
    end
    
    % Compute cross-correlation
    [cross_corr, lags] = xcorr(pos_interp, angle_interp, 'coeff');
    [~, max_idx] = max(cross_corr);
    lag = lags(max_idx);
    
    % Calculate phase difference
    dt = mean(diff(common_time));  % Time step
    time_lag = lag * dt;
    phase_diff = -2 * pi * time_lag / period;  % Negative sign accounts for lag vs. lead
    
    % Wrap phase difference to [-pi, pi]
    phase_diff = mod(phase_diff + pi, 2*pi) - pi;
end
