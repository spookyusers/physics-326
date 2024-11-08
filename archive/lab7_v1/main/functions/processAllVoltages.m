% processAllVoltages.m
%
% Processes data files for a set of voltages and returns a results table.
%
% Inputs:
%   voltages   - Array of voltage values to process.
%   dataFolder - Folder where the data files are located.
%
% Outputs:
%   results_table - Table containing the results for each voltage.

function results_table = processAllVoltages(voltages, dataFolder)
    n_files = length(voltages);
    periods = zeros(n_files, 1);
    amplitudes = zeros(n_files, 1);
    phase_diffs = zeros(n_files, 1);
    frequencies = zeros(n_files, 1);

    for i = 1:n_files
        [periods(i), amplitudes(i), phase_diffs(i), frequencies(i)] = ...
            processVoltageFile(voltages(i), dataFolder);
    end

    % Calculate maximum velocity
    v_max = frequencies .* amplitudes;

    % Compile results into a table
    results_table = table(voltages(:), periods, frequencies, amplitudes, phase_diffs, v_max, ...
        'VariableNames', {'Voltage', 'Period', 'Frequency', 'Amplitude', 'Phase', 'Vmax'});

    % Remove rows with NaN values (if any files were skipped)
    results_table = results_table(~any(ismissing(results_table), 2), :);
end
