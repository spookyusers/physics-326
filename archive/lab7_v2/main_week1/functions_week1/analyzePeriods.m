%% Function to analyze periods with error estimation
function [avg_period, std_period, frequency, freq_uncertainty] = analyzePeriods(time, position_centered)
    
    % Find zero crossings
    pos_crossings = position_centered(1:end-1) >= 0 & position_centered(2:end) < 0;
    zero_crossing_times = time(pos_crossings);
    
    % Calculate individual periods
    periods = diff(zero_crossing_times(1:2:end));
    
    % Calculate statistics
    avg_period = mean(periods);
    std_period = std(periods);
    
    % Calculate frequency and its uncertainty
    frequency = 1/avg_period;
    freq_uncertainty = std_period/(avg_period^2);  
end