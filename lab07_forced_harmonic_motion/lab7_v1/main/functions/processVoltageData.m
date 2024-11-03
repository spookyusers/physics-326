% processVoltageData.m
%
% Processes forced oscillation data for Damping Case 1 and calculates
% periods, amplitudes, phase differences, frequencies, and maximum velocities.
%
% Inputs:
%   voltages   - Array of voltage values (e.g., [468, 478, ...])
%   dataFolder - Folder where the data files are located
%
% Outputs:
%   results_table - Table containing processed results with columns:
%                   Voltage, Period, Frequency, Amplitude, Phase, Vmax

function results_table = processVoltageData(voltages, dataFolder)
    n_files = length(voltages);
    periods = zeros(n_files, 1);
    amplitudes = zeros(n_files, 1);
    phase_diffs = zeros(n_files, 1);
    frequencies = zeros(n_files, 1);

    for i = 1:n_files
        voltage = voltages(i); % Voltage as integer, e.g., 468

        % Construct the filename
        filename = sprintf('%dV.txt', voltage);
        filepath = fullfile(dataFolder, filename);

        % Check if the file exists and process
        if isfile(filepath)
            try
                % Read the data with original variable names preserved
                data = readtable(filepath, 'VariableNamingRule', 'preserve');

                % Verify required columns
                requiredColumns = {'Time', 'Position', 'Angle 2'};
                actualColumns = data.Properties.VariableNames;

                missingColumns = setdiff(requiredColumns, actualColumns);
                if ~isempty(missingColumns)
                    error('Missing columns: %s', strjoin(missingColumns, ', '));
                end

                % Extract time, position, and angle columns using exact header names
                time = data.('Time');         % Access the 'Time' column
                position = data.('Position'); % Access the 'Position' column
                angle = data.('Angle 2');     % Access the 'Angle 2' column

                % Process the data using your existing function
                [period, amplitude, phase_diff] = analyzeForcedOscillation(time, position, angle);

                % Store the results
                periods(i) = period;
                amplitudes(i) = amplitude;
                phase_diffs(i) = phase_diff;
                frequencies(i) = 2 * pi / period;
            catch ME
                warning('Error processing file %s: %s', filepath, ME.message);
                periods(i) = NaN;
                amplitudes(i) = NaN;
                phase_diffs(i) = NaN;
                frequencies(i) = NaN;
            end
        else
            warning('File %s not found.', filepath);
            periods(i) = NaN;
            amplitudes(i) = NaN;
            phase_diffs(i) = NaN;
            frequencies(i) = NaN;
        end
    end

    % Apply phase unwrapping
    phase_diffs_unwrapped = unwrap(phase_diffs);

    % Calculate maximum velocity
    v_max = frequencies .* amplitudes;

    % Compile results into a table
    results_table = table(voltages(:) / 100, periods, frequencies, amplitudes, phase_diffs_unwrapped, v_max, ...
        'VariableNames', {'Voltage', 'Period', 'Frequency', 'Amplitude', 'Phase', 'Vmax'});

    % Remove rows with NaN values
    results_table = results_table(~any(ismissing(results_table), 2), :);
end
