% processNaturalFrequencyCase.m
%
% Processes a natural frequency case and calculates the average period,
% standard deviation of the period, frequency, and frequency uncertainty.
%
% Inputs:
%   filename      - Name of the data file for the case
%   dataFolder    - Folder where the data files are located
%
% Outputs:
%   avg_period       - Average period of oscillation (seconds)
%   std_period       - Standard deviation of the periods (seconds)
%   frequency        - Calculated frequency (Hz)
%   freq_uncertainty - Uncertainty in the frequency (Hz)

function [avg_period, std_period, frequency, freq_uncertainty] = ...
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
    [avg_period, std_period, frequency, freq_uncertainty] = ...
        analyzePeriods(time, position_centered);
end
