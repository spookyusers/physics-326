% -----------------------------------------------------------------
% Function to calculate period, phase difference, and return results
% -----------------------------------------------------------------
function [average_period, period_uncertainty, phase_diff] = periodPhase_v2(timeData, massPositionData, rotaryArmAngleData)
    
    % Subtract the mean from the mass position data to center it around zero
    massPositionShifted = massPositionData - mean(massPositionData);
    
    % Find zero crossings for detrended mass position data
    positivePositions = massPositionShifted >= 0;
    negativePositions = massPositionShifted < 0;
    zeroCrossingIndicesMass = positivePositions(1:end-1) & negativePositions(2:end);
    zeroCrossingTimesMass = timeData(zeroCrossingIndicesMass); % Zero crossing times from detrended mass data
    
    % Check if there are enough zero crossings
    if length(zeroCrossingTimesMass) < 2
        error('Not enough zero crossings detected in mass position data.');
    end
    
    % Extract full periods by considering every second zero crossing
    % Assuming consistent oscillation, take every second crossing
    fullPeriodZeroCrossings = zeroCrossingTimesMass(1:2:end);
    
    % Ensure there are enough full period crossings
    if length(fullPeriodZeroCrossings) < 2
        error('Not enough full period zero crossings detected.');
    end
    
    % Calculate individual periods
    individual_periods = diff(fullPeriodZeroCrossings); % Time between consecutive full periods
    
    % Calculate average period and uncertainty
    average_period = mean(individual_periods);
    period_uncertainty = std(individual_periods);
    
    % Calculate Phase Difference
    % --------------------------
    
    % Find zero crossings for rotary arm angle data
    positiveAngles = rotaryArmAngleData >= 0;
    negativeAngles = rotaryArmAngleData < 0;
    zeroCrossingIndicesRotary = positiveAngles(1:end-1) & negativeAngles(2:end);
    zeroCrossingTimesRotary = timeData(zeroCrossingIndicesRotary); % Zero crossing times from rotary arm data
    
    % Ensure we have enough crossings to compare
    n_crossings_compare = min(length(fullPeriodZeroCrossings), length(zeroCrossingTimesRotary));
    zeroCrossingTimesMass = fullPeriodZeroCrossings(1:n_crossings_compare);
    zeroCrossingTimesRotary = zeroCrossingTimesRotary(1:n_crossings_compare);
    
    % Calculate the average time lag between the two signals
    timeLags = zeroCrossingTimesMass - zeroCrossingTimesRotary; % Time difference for each corresponding crossing
    avgTimeLag = mean(timeLags); % Average time lag across all zero crossings
    
    % Calculate phase difference (delta_phi) in radians
    phase_diff = mod((2 * pi * avgTimeLag) / average_period, 2*pi);
    
    % Adjust phase_diff to lie within [-pi, pi]
    if phase_diff > pi
        phase_diff = phase_diff - 2*pi;
    end
end
