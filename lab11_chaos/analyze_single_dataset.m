% Improved visualization script
clear; clc; close all;

% File paths
ch1_file = './clean_data/ALL0000/clean_f0000ch1.csv';
ch2_file = './clean_data/ALL0000/clean_f0000ch2.csv';

% Read raw data
V0_data = readmatrix(ch1_file, 'NumHeaderLines', 1);  % Driving voltage
VR_data = readmatrix(ch2_file, 'NumHeaderLines', 1);  % Response voltage

% Extract time and voltage
t = V0_data(:,1);
V0 = V0_data(:,2);
VR = VR_data(:,2);

% Create figure
figure('Position', [100 100 1200 800]);

% Plot 1: Time domain signals - full resolution
subplot(2,2,[1 2])
plot(t, V0, 'b-', 'LineWidth', 1, 'DisplayName', 'V_0');
hold on;
plot(t, VR, 'r-', 'LineWidth', 1, 'DisplayName', 'V_R');
xlabel('Time (s)');
ylabel('Voltage (V)');
title('Time Domain Signals');
grid on;
legend('Location', 'best');

% Plot 2: Lissajous figure with proper scaling
subplot(2,2,3)
plot(V0, VR, '.', 'MarkerSize', 1);
xlabel('V_0 (V)');
ylabel('V_R (V)');
title('Lissajous Figure');
grid on;

% Plot 3: Zoomed portion of time signals
subplot(2,2,4)
% Plot 100 points starting from the middle of the dataset
mid_point = round(length(t)/2);
plot_range = mid_point:(mid_point+100);
plot(t(plot_range), V0(plot_range), 'b.-', 'LineWidth', 1, 'MarkerSize', 10, 'DisplayName', 'V_0');
hold on;
plot(t(plot_range), VR(plot_range), 'r.-', 'LineWidth', 1, 'MarkerSize', 10, 'DisplayName', 'V_R');
xlabel('Time (s)');
ylabel('Voltage (V)');
title('Zoomed Time Domain (100 points)');
grid on;
legend('Location', 'best');

% Print key statistics
fprintf('\nSignal Statistics:\n');
fprintf('Driving Voltage (V0) range: %.3f to %.3f V\n', min(V0), max(V0));
fprintf('Response Voltage (VR) range: %.3f to %.3f V\n', min(VR), max(VR));
fprintf('Sampling frequency: %.2f kHz\n', 1/mean(diff(t))/1000);