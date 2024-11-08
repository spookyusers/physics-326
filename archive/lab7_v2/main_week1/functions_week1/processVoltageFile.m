function [period, amplitude, phase_diff, omega] = processVoltageFile(voltage, dataFolder)
    % Construct filename
    filename = fullfile(dataFolder, sprintf('clean_Lab7_%.2fV.txt', voltage));

    % Check if the file exists
    if ~isfile(filename)
        warning('File %s does not exist. Skipping this voltage.', filename);
        period = NaN;
        amplitude = NaN;
        phase_diff = NaN;
        omega = NaN;
        return;
    end

    % Load data from file
    data = readtable(filename, 'VariableNamingRule', 'preserve');

    % Verify required columns
    requiredColumns = {'Time', 'Position', 'Angle2'};
    if ~all(ismember(requiredColumns, data.Properties.VariableNames))
        warning('Required columns are missing in %s. Skipping this file.', filename);
        period = NaN;
        amplitude = NaN;
        phase_diff = NaN;
        omega = NaN;
        return;
    end

    % Extract necessary columns
    time = data.Time;
    position = data.Position;
    angle = data.Angle2;

    % Analyze the data using your analyzeForcedOscillation function
    [period, amplitude, phase_diff] = analyzeForcedOscillation(time, position, angle);

    % Calculate angular frequency in rad/s
    omega = 2 * pi / period;
end
