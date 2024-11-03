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
        if exist(filepath, 'file')
            % Read the data with original variable names
            data = readtable(filepath, 'VariableNamingRule', 'preserve');

            % Extract time, position, and angle columns
            time = data.('Time');       % Use parentheses and quotes
            position = data.('Position');
            angle = data.('Angle 2');

            % Process the data using your existing function
            [period, amplitude, phase_diff] = analyzeForcedOscillation(time, position, angle);

            % Store the results
            periods(i) = period;
            amplitudes(i) = amplitude;
            phase_diffs(i) = phase_diff;
            frequencies(i) = 2 * pi / period;
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
