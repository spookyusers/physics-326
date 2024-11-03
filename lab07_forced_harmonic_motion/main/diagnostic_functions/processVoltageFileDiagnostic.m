% processVoltageFileDiagnostic.m
%
% Processes the data file corresponding to the given voltage with diagnostic output.
%
% Inputs:
%   voltage    - Driving voltage of the motor (in volts)
%   dataFolder - Directory where data files are located
%
% Outputs:
%   period     - Measured oscillation period (in seconds)
%   amplitude  - Measured oscillation amplitude (in meters)
%   phase_diff - Measured phase difference (in radians)
%   frequency  - Angular frequency calculated from the period (in rad/s)

function [period, amplitude, phase_diff, frequency] = processVoltageFileDiagnostic(voltage, dataFolder)
    % Construct filename
    filename = fullfile(dataFolder, sprintf('clean_Lab7_%.2fV.txt', voltage));
    
    % Check if the file exists
    if ~isfile(filename)
        error('File %s does not exist.', filename);
    end
    
    % Load data from file
    data = readtable(filename);
    
    % Verify required columns
    requiredColumns = {'Time', 'Position', 'Angle2'};
    if ~all(ismember(requiredColumns, data.Properties.VariableNames))
        error('Required columns are missing in %s.', filename);
    end
    
    % Extract necessary columns
    time = data.Time;
    position = data.Position;
    angle = data.Angle2;
    
    % Check for missing or NaN values
    if any(isnan(time)) || any(isnan(position)) || any(isnan(angle))
        error('Data contains NaN values in %s.', filename);
    end
    
    % Analyze the data
    [period, amplitude, phase_diff] = analyzeForcedOscillationDiagnostic(time, position, angle, voltage);
    
    % Calculate angular frequency
    frequency = 2 * pi / period;
end
