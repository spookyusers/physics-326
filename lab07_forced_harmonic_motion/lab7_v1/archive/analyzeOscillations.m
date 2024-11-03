% MATLAB Function: analyzeOscillations.m
% Purpose: Analyze oscillatory behavior by identifying peaks and calculating periods and phase differences

function [avgPeriod, periodError, phaseDiff] = analyzeOscillations(Time, Position, Angle2)
    % analyzeOscillations analyzes oscillatory behavior by identifying peaks
    % Inputs:
    %   Time - Vector of time data
    %   Position - Shifted Position data vector (oscillates around zero)
    %   Angle2 - Vector of Angle2 data
    % Outputs:
    %   avgPeriod - Average period between oscillations
    %   periodError - Standard deviation of the periods
    %   phaseDiff - Average phase difference between Position and Angle2 at peaks

    % Initialize arrays to store peak times and corresponding angles
    peakTimes = [];
    peakAngles = [];
    
    % Simple peak detection: a point is a peak if it's greater than its neighbors
    for j = 2:length(Position)-1
        if Position(j) > Position(j-1) && Position(j) > Position(j+1)
            peakTimes(end+1) = Time(j); %#ok<AGROW>
            peakAngles(end+1) = Angle2(j); %#ok<AGROW>
        end
    end
    
    % Check if enough peaks are found
    if length(peakTimes) < 2
        avgPeriod = NaN;
        periodError = NaN;
        phaseDiff = NaN;
        warning('Not enough peaks detected to perform analysis.');
        return;
    end
    
    % Calculate periods between successive peaks
    periods = diff(peakTimes);
    
    % Calculate average period and standard deviation
    avgPeriod = mean(periods);
    periodError = std(periods);
    
    % Calculate phase differences at each peak
    % Phase difference is the Angle2 value at each peak
    % This assumes that a positive Angle2 corresponds to a leading phase
    % and a negative Angle2 corresponds to a lagging phase
    phaseDiffs = peakAngles;
    
    % Calculate average phase difference
    phaseDiff = mean(phaseDiffs);
end
