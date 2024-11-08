function [avg_period, std_period, frequency, freq_uncertainty] = analyzePeriods(time, position_centered)
    % analyzePeriods
    % Analyzes the periods of oscillation from position vs. time data.
    %
    % Inputs:
    %   time             - Time vector (s)
    %   position_centered - Centered position data (m)
    %
    % Outputs:
    %   avg_period       - Average period of oscillation (s)
    %   std_period       - Standard deviation of the periods (s)
    %   frequency        - Calculated frequency (Hz)
    %   freq_uncertainty - Uncertainty in the frequency (Hz)
    
    %% Peak Detection
    % Detrend the position data to remove any linear trend
    position_detrended = detrend(position_centered);

    % Find peaks (maxima) in the position data
    [~, locs_max] = findpeaks(position_detrended, time);

    % Find troughs (minima) in the position data by inverting it
    [~, locs_min] = findpeaks(-position_detrended, time);

    % Combine maxima and minima locations
    locs_all = sort([locs_max; locs_min]);

    % Calculate individual half-periods
    half_periods = diff(locs_all);

    % Ensure an even number of half-periods
    if mod(length(half_periods), 2) ~= 0
        half_periods = half_periods(1:end-1);
    end

    % Sum pairs of half-periods to get full periods
    periods = half_periods(1:2:end) + half_periods(2:2:end);

    % Ensure we have enough periods for statistical analysis
    if length(periods) < 2
        warning('Not enough periods detected for reliable analysis.');
        avg_period = NaN;
        std_period = NaN;
        frequency = NaN;
        freq_uncertainty = NaN;
        return;
    end

    %% Period Statistics
    avg_period = mean(periods);
    std_period = std(periods);

    %% Frequency Calculation
    frequency = 1 / avg_period;  % Frequency in Hz

    %% Frequency Uncertainty
    freq_uncertainty = std_period / (avg_period^2);
end
