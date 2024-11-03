% processVoltageDataCombined.m
%
% Processes voltage data for any damping case by handling filename prefixes.
%
% Inputs:
%   voltages   - Array of voltages (e.g., [478, 492, ...])
%   dataFolder - Path to the data folder (e.g., 'damping_case1' or 'damping_case2')
%   prefix     - String prefix for filenames (e.g., 'NoPlate' or '')
%
% Outputs:
%   results_table - Table containing Voltage_V, Period_s, Frequency_rad_s, Amplitude_m, Phase_rad, and Vmax_m_s

function results_table = processVoltageDataCombined(voltages, dataFolder, prefix)
    % Number of files to process
    n_files = length(voltages);
    
    % Preallocate arrays for efficiency
    periods = zeros(n_files, 1);
    amplitudes = zeros(n_files, 1);
    phase_diffs = zeros(n_files, 1);
    frequencies = zeros(n_files, 1);
    
    for i = 1:n_files
        voltage = voltages(i); % Voltage as integer, e.g., 478
    
        % Construct the filename with optional prefix
        if isempty(prefix)
            filename = sprintf('%dV.txt', voltage);
        else
            filename = sprintf('%s%dV.txt', prefix, voltage);
        end
        filepath = fullfile(dataFolder, filename);
    
        % Check if the file exists and process
        if isfile(filepath)
            try
                % Read the data with original variable names preserved
                data = readtable(filepath, 'VariableNamingRule', 'preserve');
    
                % Define required columns
                requiredColumns = {'Time', 'Position', 'Angle 2'};
                actualColumns = data.Properties.VariableNames;
    
                % Check for missing columns
                missingColumns = setdiff(requiredColumns, actualColumns);
                if ~isempty(missingColumns)
                    error('Missing columns: %s', strjoin(missingColumns, ', '));
                end
    
                % Extract time, position, and angle columns using exact header names
                time = data.('Time');         % Access the 'Time' column
                position = data.('Position'); % Access the 'Position' column
                angle = data.('Angle 2');     % Access the 'Angle 2' column
    
                % Center the position data around zero (optional, based on your analysis needs)
                position_centered = position - mean(position);
    
                % Process the data using your existing function
                [period, amplitude, phase_diff] = analyzeForcedOscillation(time, position_centered, angle);
    
                % Store the results
                periods(i) = period;
                amplitudes(i) = amplitude;
                phase_diffs(i) = phase_diff;
                frequencies(i) = 2 * pi / period; % Angular frequency (rad/s)
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
    
    % Compile results into a table with appropriate variable names and units
    results_table = table(voltages(:) / 100, periods, frequencies, amplitudes, phase_diffs_unwrapped, v_max, ...
        'VariableNames', {'Voltage_V', 'Period_s', 'Frequency_rad_s', 'Amplitude_m', 'Phase_rad', 'Vmax_m_s'});
    
    % Remove rows with any NaN values to ensure data integrity
    results_table = results_table(~any(ismissing(results_table), 2), :);
end
