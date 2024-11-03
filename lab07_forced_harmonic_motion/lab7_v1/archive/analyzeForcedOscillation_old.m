function [period, amplitude, phase_diff] = analyzeForcedOscillation(time, position, angle)
    % analyzeForcedOscillation analyzes oscillation data to extract key parameters
    %
    % This function takes time series data from a forced oscillation experiment
    % and calculates three key parameters:
    % 1. The period of oscillation
    % 2. The amplitude of the position oscillation
    % 3. The phase difference between position and driving force
    %
    % Inputs:
    %   time - Vector of time points
    %   position - Vector of position measurements of the oscillating mass
    %   angle - Vector of angle measurements from the driving force
    %
    % Outputs:
    %   period - Average period of oscillation (seconds)
    %   amplitude - Amplitude of position oscillation (meters)
    %   phase_diff - Phase difference between position and angle (radians)
    
    %% Period Calculation
    % Center the position data around zero by subtracting the mean
    % This helps identify zero crossings more accurately
    pos_centered = position - mean(position);
    
    % Find where signal crosses from positive to negative
    % This creates a logical array where true indicates a crossing
    % We use 1:end-1 and 2:end to compare adjacent points
    pos_crossings = pos_centered(1:end-1) >= 0 & pos_centered(2:end) < 0;
    
    % Get the times when these crossings occur
    zero_crossing_times = time(pos_crossings);
    
    % Calculate periods by taking differences between every other crossing
    % Every other crossing gives a full period (from one negative crossing to the next)
    periods = diff(zero_crossing_times(1:2:end));
    
    % Average all periods to get mean period
    period = mean(periods);
    
    %% Amplitude Calculation
    % Calculate amplitude as half the peak-to-peak distance
    % This is more robust than just taking the maximum value
    amplitude = (max(position) - min(position))/2;
    
    %% Phase Difference Calculation
    % Find peaks in both position and angle signals
    % MinPeakDistance helps avoid finding false peaks due to noise
    % We set it to roughly 1/20th of the data length
    min_peak_dist = round(length(time)/20);
    [~, pos_peak_locs] = findpeaks(position, 'MinPeakDistance', min_peak_dist);
    [~, angle_peak_locs] = findpeaks(angle, 'MinPeakDistance', min_peak_dist);
    
    % Determine how many peaks to use for phase calculation
    % We use up to 5 peaks or however many we found (whichever is smaller)
    % This helps average out noise while avoiding edge effects:
    % - Start of data: system might not be in steady state yet
    % - End of data: might have truncated oscillations or system slowdown
    % - Middle peaks give most representative behavior of the system
    num_peaks = min(5, min(length(pos_peak_locs), length(angle_peak_locs)));
    
    % Initialize array to store phase differences
    % We use num_peaks-1 because:
    % - With N peaks, we can calculate N-1 differences between consecutive peaks
    % - Example: 5 peaks gives us 4 phase differences (1→2, 2→3, 3→4, 4→5)
    phase_diffs = zeros(num_peaks-1, 1);
    
    % Calculate phase differences for each pair of peaks
    for i = 1:num_peaks-1  % Loop runs from 1 to (num_peaks-1)
        % Find time difference between corresponding peaks
        time_diff = time(pos_peak_locs(i)) - time(angle_peak_locs(i));
        
        % Convert time difference to phase difference
        % Phase = 2*pi * (time difference / period)
        phase_diffs(i) = 2*pi * (time_diff/period);
        
        % Wrap phase to interval [-pi, pi]
        % Phase wrapping is necessary because:
        % - A phase of -3pi and pi represent the same phase relationship
        % - We want all phases reported in consistent [-pi, pi] range
        % - Examples: 
        %   * 4pi/3 becomes -2pi/3 (subtract 2pi once)
        %   * -4pi/3 becomes 2pi/3 (add 2pi once)
        % Without wrapping:
        % - We might report 7pi/4 instead of -pi/4
        % - Would get artificial jumps in phase plots
        while phase_diffs(i) > pi
            phase_diffs(i) = phase_diffs(i) - 2*pi;
        end
        while phase_diffs(i) < -pi
            phase_diffs(i) = phase_diffs(i) + 2*pi;
        end
    end
    
    % Average all phase differences to get final result
    phase_diff = mean(phase_diffs);
end