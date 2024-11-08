% analyzeForcedOscillationDiagnostic.m
%
% Analyzes oscillation data with diagnostics.
%
% Inputs:
%   time     - Vector of time points
%   position - Vector of position measurements
%   angle    - Vector of angle measurements
%   voltage  - The voltage value for identification
%
% Outputs:
%   period     - Calculated period of oscillation (seconds)
%   amplitude  - Calculated amplitude of oscillation (meters)
%   phase_diff - Calculated phase difference (radians)

function [period, amplitude, phase_diff] = analyzeForcedOscillationDiagnostic(time, position, angle, voltage)
    %% Period Calculation
    % Detrend and center the position data
    position = detrend(position);
    pos_centered = position - mean(position);
    
    % Find peaks in the position data to calculate the period
    [pks_pos, locs_pos] = findpeaks(pos_centered, time);
    if length(locs_pos) < 2
        error('Not enough peaks found to calculate period for voltage %.2f V.', voltage);
    end
    periods = diff(locs_pos);
    period = mean(periods);
    
    % Output period information
    fprintf('Voltage %.2f V: Calculated period is %.4f s.\n', voltage, period);
    
    %% Amplitude Calculation
    amplitude = (max(pos_centered) - min(pos_centered)) / 2;
    
    % Output amplitude information
    fprintf('Voltage %.2f V: Calculated amplitude is %.4f m.\n', voltage, amplitude);
    
    %% Phase Difference Calculation
    % Ensure angle data is in radians
    if max(abs(angle)) > 2*pi
        angle = deg2rad(angle);
    end
    angle = angle - mean(angle);
    
    % Interpolate signals onto a common time vector
    common_time = linspace(min(time), max(time), length(time)*10);
    pos_interp = interp1(time, pos_centered, common_time);
    angle_interp = interp1(time, angle, common_time);
    
    % Compute cross-correlation
    [cross_corr, lags] = xcorr(pos_interp, angle_interp, 'coeff');
    [~, max_idx] = max(cross_corr);
    lag = lags(max_idx);
    dt = mean(diff(common_time));
    time_lag = lag * dt;
    phase_diff = -2 * pi * time_lag / period;
    
    % Wrap phase difference to [-pi, pi]
    phase_diff = mod(phase_diff + pi, 2*pi) - pi;
    
    % Output phase difference information
    fprintf('Voltage %.2f V: Calculated phase difference is %.4f rad.\n', voltage, phase_diff);
    
    % Check for anomalies in phase difference
    if abs(phase_diff) > pi
        warning('Voltage %.2f V: Phase difference exceeds expected range.', voltage);
    end
end
