% Lab 11 part 6-1a
clear; clc; close all;

% Data folder
dataFolder = './oscill_data/ALL0000/';

% File names
filename_ch1 = 'F0000CH1.CSV';
filename_ch2 = 'F0000CH2.CSV';

% Construct full file path
filePath_ch1 = fullfile(dataFolder, filename_ch1);
filePath_ch2 = fullfile(dataFolder, filename_ch2);

% Read the file as text to skip the metadata
raw_data_ch1 = readtable(filePath_ch1);
raw_data_ch2 = readtable(filePath_ch2);

% Separate time and voltage columns
time_ch1 = raw_data_ch1.Time;  % First column: Time
voltage_ch1 = raw_data_ch1.Voltage; % Second column: Voltage
time_ch2 = raw_data_ch2.Time;  % First column: Time
voltage_ch2 = raw_data_ch2.Voltage; % Second column: Voltage

% Plot Oscilloscope Data Channel 1, Vr
figure;
plot(time_ch1, voltage_ch1, 'LineWidth', 1.5);
title('Oscilloscope Voltage (Vr vs Time)');
xlabel('Time (s)');

% Plot Oscilloscope Data Channel 2, V0
figure;
plot(time_ch1, voltage_ch2, 'LineWidth', 1.5);
title('Oscilloscope Voltage (V0 vs Time)');
xlabel('Time (s)');

% Plot V0 vs VR
figure;
plot(voltage_ch1,voltage_ch2);
title('V_0 vs V_r');
xlabel('V_0');
ylabel('V_r');

%% dbv and kHz
an1 = -40.06; freq1 = 10.813; 
an2 = -64.74; freq2 = 8.091; 
an3 = -47.90; freq3 = 5.406;
an4 = -57.40; freq4 = 2.6875; % kHz

% Calculate Time Intervals Between Peaks for Channel 1 (Vr)
time_intervals = diff(locs_ch1); % Differences between successive peak times

% Plot Peak Intervals to Identify Period Doubling
figure;
plot(locs_ch1(1:end-1), time_intervals, '-o', 'LineWidth', 1.5);
title('Time Intervals Between Peaks (Vr)');
xlabel('Time (s)');
ylabel('Interval Duration (s)');
grid on;

% Check for Period Doubling
threshold_period = mean(time_intervals); % Initial average period (single period)
period_doubling_indices = find(time_intervals > 1.5 * threshold_period); % Detect significant changes

% Mark Period Doubling Thresholds
hold on;
plot(locs_ch1(period_doubling_indices), time_intervals(period_doubling_indices), 'r*', 'MarkerSize', 10);
legend('Peak Intervals', 'Period Doubling Points');
hold off;

% Display Period Doubling Points
disp('Period Doubling Threshold Times (Vr):');
disp(locs_ch1(period_doubling_indices));

% Fourier Spectrum Analysis
% Load SR760 Spectrum Data
frequency = sr_data(:, 1); % Frequency column
amplitude = sr_data(:, 2); % Amplitude column

% Plot Fourier Spectrum
figure;
plot(frequency, amplitude, 'LineWidth', 1.5);
title('SR760 Frequency Spectrum');
xlabel('Frequency (Hz)');
ylabel('Amplitude');
grid on;

% Detect Half-Frequency Peaks (Period Doubling)
[~, freq_locs] = findpeaks(amplitude, frequency, 'MinPeakHeight', 0.1); % Adjust threshold
disp('Detected Frequencies for Period Doubling:');
disp(freq_locs);

% Combine Results
period_doubling_values = voltage_ch1(period_doubling_indices); % Corresponding V0 values
disp('Estimated Period Doubling Threshold Values (V0):');
disp(period_doubling_values);

%% Data from laskdjfs
% pretzelstart = .364; %V
% d1 = 