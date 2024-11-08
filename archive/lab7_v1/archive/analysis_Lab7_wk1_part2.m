% Process forced oscillation data for all voltage files
% This script analyzes data from forced oscillation experiments at different driving voltages
% For each voltage, it calculates:
% - Period of oscillation
% - Angular frequency (2*pi/T)
% - Amplitude of oscillation
% - Phase difference between position and driving force

% List of voltages (excluding 2.00V which showed irregular behavior)
% These voltages correspond to different driving frequencies of the motor
% The range covers frequencies below and above the expected resonance
voltages = [3.18, 4.14, 4.25, 4.35, 4.45, 4.55, 4.65, 4.78, 4.85, ...
           4.95, 5.05, 5.16, 5.26, 5.35, 6.00, 9.50];

% Initialize arrays to store results from each voltage file
% All arrays are initialized as column vectors for consistency
n_files = length(voltages);
periods = zeros(n_files, 1);      % Oscillation periods
amplitudes = zeros(n_files, 1);   % Oscillation amplitudes
phase_diffs = zeros(n_files, 1);  % Phase differences
frequencies = zeros(n_files, 1);  % Angular frequencies

% Process each voltage file
% The files contain time series data of position and angle measurements
for i = 1:n_files
    % Construct filename using the voltage value
    % Files are named in format 'clean_Lab7_X.XXV.txt'
    filename = sprintf('clean_Lab7_%.2fV.txt', voltages(i));
    
    % Load data from file
    % Each file contains columns for Time, Position, and Angle2 (among others)
    data = readtable(filename);
    time = data.Time;         % Time points of measurements
    position = data.Position; % Position of the oscillating mass
    angle = data.Angle2;      % Angle of the driving force
    
    % Analyze the data using our analyzeForcedOscillation function
    % This function finds peaks and calculates period, amplitude, and phase
    [periods(i), amplitudes(i), phase_diffs(i)] = analyzeForcedOscillation(time, position, angle);
    
    % Calculate angular frequency from the period
    % angular_freq = 2*pi/T where T is the period
    frequencies(i) = 2*pi/periods(i);
end

% Display results in a formatted table
% This helps visualize trends in the data
fprintf('\nResults:\n');
fprintf('Voltage (V)\tPeriod (s)\tFreq (rad/s)\tAmplitude (m)\tPhase (rad)\n');
fprintf('--------------------------------------------------------\n');
for i = 1:n_files
    fprintf('%.2f\t\t%.3f\t\t%.3f\t\t%.3f\t\t%.3f\n', ...
            voltages(i), periods(i), frequencies(i), amplitudes(i), phase_diffs(i));
end

% Save results in a MATLAB table for later analysis
% The (:) ensures all vectors are column vectors
% Variables stored:
% - Voltage: driving voltage of the motor
% - Period: measured oscillation period
% - Frequency: calculated angular frequency (omega)
% - Amplitude: measured oscillation amplitude
% - Phase: measured phase difference between position and driving force
results_table = table(voltages(:), periods, frequencies(:), amplitudes, phase_diffs, ...
    'VariableNames', {'Voltage', 'Period', 'Frequency', 'Amplitude', 'Phase'});

% Notes on the results:
% 1. The amplitude shows a clear peak around 4.78V, indicating resonance
% 2. As frequency increases (voltage increases), period decreases as expected
% 3. Phase differences show systematic change but with some jumps
%    that might need additional processing
% 4. The frequency range spans from about 1.6 to 5.5 radians per second
%
% Additional physics notes:
% - At resonance (around 4.78V), the natural frequency equals the driving frequency
% - The phase difference changes from near 0 below resonance to -pi above resonance
% - The amplitude peak at resonance is finite due to damping in the system
%% Plot experimental data for forced oscillations

% Create figure with good size for detailed viewing
figure('Position', [100, 100, 800, 500])

% Plot amplitude vs frequency
plot(frequencies, amplitudes, 'bo-', 'LineWidth', 1.5, 'MarkerSize', 8)

% Add title and labels
title('Amplitude vs Angular Frequency (Large Damping Disc)', 'FontSize', 14)
xlabel('Angular Frequency omega (rad/s)', 'FontSize', 12)
ylabel('Amplitude A (m)', 'FontSize', 12)

% Add grid for better readability
grid on

% Adjust axes to start from 0 and include all data points with some padding
xlim([0, max(frequencies)*1.1])
ylim([0, max(amplitudes)*1.1])

% Calculate v_max
v_max = frequencies .* amplitudes;

% Create figure
figure('Position', [100, 100, 800, 500])

% Plot data points with open circles and connecting lines
plot(frequencies, v_max, 'o-r', 'MarkerSize', 8)

% Add title and labels
title('Maximum Velocity vs Angular Frequency (Large Damping Disc)', 'FontSize', 14)
xlabel('Angular Frequency omega (rad/s)', 'FontSize', 12)
ylabel('Maximum Velocity v max (m/s)', 'FontSize', 12)

% Add grid
grid on

% Find peak and calculate 0.707 level
[peak_v_max, peak_idx] = max(v_max);
omega_0 = frequencies(peak_idx);
v_707 = 0.707 * peak_v_max;

% Add peak marker
hold on
plot(omega_0, peak_v_max, 'k*', 'MarkerSize', 12)
text(omega_0, peak_v_max*1.05, 'omega 0 = 2.55 rad/s')

% Add 0.707 line and text
plot([2, 5], [v_707, v_707], 'k--')
text(2, v_707*1.05, '0.707 v max')
text(2, v_707*0.95, 'bandwidth = 0.66 rad/s')

% Set axis limits
xlim([0 6])
ylim([0 0.45])

