function [avg_period, std_period, frequency_hz, freq_uncertainty_hz] = ...
    processNaturalFrequencyCase(filename, dataFolder)

    % Construct full file path
    filePath = fullfile(dataFolder, filename);

    % Check if the file exists
    if ~isfile(filePath)
        error('File %s does not exist.', filePath);
    end

    % Load data from file with original column headers preserved
    data = readtable(filePath, 'VariableNamingRule', 'preserve');

    % Verify required columns using exact header names
    requiredColumns = {'Time', 'Position'};
    actualColumns = data.Properties.VariableNames;

    % Check if all required columns are present
    missingColumns = setdiff(requiredColumns, actualColumns);
    if ~isempty(missingColumns)
        error('Required columns are missing in %s: %s', filename, strjoin(missingColumns, ', '));
    end

    % Extract necessary columns using exact header names
    time = data.('Time');       % Access the 'Time' column
    position = data.('Position'); % Access the 'Position' column

    % Center the position data around zero
    position_centered = position - mean(position);

    % Analyze periods using the provided function
    [avg_period, std_period, frequency_hz, freq_uncertainty_hz] = ...
        analyzePeriods(time, position_centered);
end
