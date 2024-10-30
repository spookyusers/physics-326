function [period, period_uncertainty, phase_diff] = analyzeOscillations(time, signal1, signal2)
    % Analyze two oscillating signals to find period and phase difference
    % Inputs:
    %   time - time data
    %   signal1 - first signal (reference)
    %   signal2 - second signal (comparison)
    % Outputs:
    %   period - average period of signal1
    %   period_uncertainty - standard deviation of period measurements
    %   phase_diff - phase difference between signals (radians)
    
    % Basic error check
    if length(time) ~= length(signal1) || length(time) ~= length(signal2)
        error('All inputs must be same length')
    end
    
    % Find zero crossings for signal1
    pos_crossings = signal1(1:end-1) < 0 & signal1(2:end) >= 0;
    crossing_times1 = time(pos_crossings);
    
    % Find zero crossings for signal2
    pos_crossings = signal2(1:end-1) < 0 & signal2(2:end) >= 0;
    crossing_times2 = time(pos_crossings);
    
    % Basic error check
    if length(crossing_times1) < 2 || length(crossing_times2) < 2
        error('Not enough zero crossings found')
    end
    
    % Calculate periods from consecutive crossings
    periods = diff(crossing_times1);
    period = mean(periods);
    period_uncertainty = std(periods);
    
    % Calculate phase difference
    time_diff = mean(crossing_times2(1:min(length(crossing_times1), length(crossing_times2))) - ...
                    crossing_times1(1:min(length(crossing_times1), length(crossing_times2))));
    phase_diff = 2 * pi * time_diff / period;
    
    % Normalize phase to [-pi, pi]
    phase_diff = mod(phase_diff + pi, 2*pi) - pi;
end