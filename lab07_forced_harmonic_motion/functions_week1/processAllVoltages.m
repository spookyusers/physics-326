function results_table = processAllVoltages(voltages, dataFolder)
    n_files = length(voltages);
    periods = zeros(n_files, 1);
    amplitudes = zeros(n_files, 1);
    phase_diffs = zeros(n_files, 1);
    omega_values = zeros(n_files, 1);  % Angular frequencies in rad/s

    for i = 1:n_files
        [periods(i), amplitudes(i), phase_diffs(i), omega_values(i)] = ...
            processVoltageFile(voltages(i), dataFolder);
    end

    % Calculate maximum velocity (v_max = omega * amplitude)
    v_max = omega_values .* amplitudes;

    % Compile results into a table
    results_table = table(voltages(:), periods, omega_values, amplitudes, phase_diffs, v_max, ...
        'VariableNames', {'Voltage', 'Period_s', 'Omega_rad_per_s', 'Amplitude_m', 'Phase_rad', 'Vmax_m_per_s'});

    % Remove rows with NaN values (if any files were skipped)
    results_table = results_table(~any(ismissing(results_table), 2), :);
end
