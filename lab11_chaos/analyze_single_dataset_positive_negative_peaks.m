% Step 1: Analyze a single dataset with both positive and negative peaks
clear; clc; close all;

% Read one dataset
[time, V0, VR] = read_scope_data(0);  % ALL0000

% Plot raw data first
figure('Position', [100 100 1200 800]);

subplot(3,1,1)
plot(time, VR, 'b-')
title('Raw VR Signal')
xlabel('Time')
ylabel('VR')
grid on

% Find both positive and negative peaks
[pos_pks, pos_locs] = findpeaks(VR, 'MinPeakDistance', 10);
[neg_pks, neg_locs] = findpeaks(-VR, 'MinPeakDistance', 10);
neg_pks = -neg_pks;  % Convert back to actual negative values

% Plot peaks
subplot(3,1,2)
plot(time, VR, 'b-')
hold on
plot(time(pos_locs), pos_pks, 'r.', 'MarkerSize', 15)
plot(time(neg_locs), neg_pks, 'g.', 'MarkerSize', 15)
title('VR Signal with Both Positive and Negative Peaks')
xlabel('Time')
ylabel('VR')
legend('Signal', 'Positive Peaks', 'Negative Peaks')
grid on

% Plot peak values distribution
subplot(3,1,3)
plot([1:length(pos_pks)], pos_pks, 'r.', 'MarkerSize', 15)
hold on
plot([1:length(neg_pks)], neg_pks, 'g.', 'MarkerSize', 15)
title('Distribution of Peak Values')
xlabel('Peak Number')
ylabel('VR Peak Value')
grid on

% Print statistics
fprintf('Number of positive peaks: %d\n', length(pos_pks));
fprintf('Number of negative peaks: %d\n', length(neg_pks));
fprintf('Positive peaks range: %.4f to %.4f\n', min(pos_pks), max(pos_pks));
fprintf('Negative peaks range: %.4f to %.4f\n', min(neg_pks), max(neg_pks));