% processVoltageFile.m
%
% Processes the data file corresponding to the given voltage and calculates
% the period, amplitude, phase difference, and angular frequency of the oscillations.
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

function [period, amplitude, phase_diff, frequency] = processVoltageFile(voltage, dataFolder)
    % Construct filename
    filename = fullfile(dataFolder, sprintf('clean_Lab7_%.2fV.txt', voltage));

    % Check if the file exists
    if ~isfile(filename)
        warning('File %s does not exist. Skipping this voltage.', filename);
        period = NaN;
        amplitude = NaN;
        phase_diff = NaN;
        frequency = NaN;
        return;
    end

    % Load data from file
    data = readtable(filename,'VariableNamingRule', 'preserve');

    % Verify required columns
    requiredColumns = {'Time', 'Position', 'Angle2'};
    if ~all(ismember(requiredColumns, data.Properties.VariableNames))
        warning('Required columns are missing in %s. Skipping this file.', filename);
        period = NaN;
        amplitude = NaN;
        phase_diff = NaN;
        frequency = NaN;
        return;
    end

    % Extract necessary columns
    time = data.Time;
    position = data.Position;
    angle = data.Angle2;

    % Analyze the data using your existing function
    [period, amplitude, phase_diff] = analyzeForcedOscillation(time, position, angle);

    % Calculate angular frequency
    frequency = 2 * pi / period;
end
