% analyzePeriods.m
%
% Analyzes periods with error estimation.
%
% Inputs:
%   time              - Vector of time points
%   position_centered - Centered position data
%
% Outputs:
%   avg_period       - Average period of oscillation (seconds)
%   std_period       - Standard deviation of the periods (seconds)
%   frequency        - Calculated frequency (Hz)
%   freq_uncertainty - Uncertainty in the frequency (Hz)

function [avg_period, std_period, frequency, freq_uncertainty] = analyzePeriods(time, position_centered)

    % Find zero crossings from positive to negative
    pos_crossings = position_centered(1:end-1) >= 0 & position_centered(2:end) < 0;
    zero_crossing_times = time(pos_crossings);

    % Ensure there are enough zero crossings
    if length(zero_crossing_times) < 2
        error('Not enough zero crossings to calculate periods.');
    end

    % Calculate individual periods
    periods = diff(zero_crossing_times(1:2:end));

    % Calculate statistics
    avg_period = mean(periods);
    std_period = std(periods);

    % Calculate frequency and its uncertainty
    frequency = 1 / avg_period;
    freq_uncertainty = std_period / (avg_period^2);
end
