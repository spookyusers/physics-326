% Derriman Lab 7

%% Part 1: Natural Frequency Analysis
clc; clear; close all;

% Case 1: No Mass
data = readtable('./cleandata/clean_Lab7_EvB1.txt');
time = data.Time;
position = data.Position;
position_centered = position - mean(position);
[avg_period_no_mass, std_period_no_mass, freq_no_mass, freq_no_mass_uncertainty] = analyzePeriods(time, position_centered);
figure;
plot(time, position_centered);
title('Case 1: No Mass');
xlabel('Time (s)');
ylabel('Position (centered)');
grid on;

% Case 2: Equivalent Mass
data = readtable('./cleandata/clean_Lab7_EvA1.txt');
time = data.Time;
position = data.Position;
position_centered = position - mean(position);
[avg_period_equiv, std_period_equiv, freq_equiv, freq_equiv_uncertainty] = analyzePeriods(time, position_centered);
figure;
plot(time, position_centered);
title('Case 2: Equivalent Mass');
xlabel('Time (s)');
ylabel('Position (centered)');
grid on;

% Case 3: With Disk
data = readtable('./cleandata/clean_Lab7_EvC1.txt');
time = data.Time;
position = data.Position;
position_centered = position - mean(position);
[avg_period_disk, std_period_disk, freq_disk, freq_disk_uncertainty] = analyzePeriods(time, position_centered);
figure;
plot(time, position_centered);
title('Case 3: With Disk');
xlabel('Time (s)');
ylabel('Position (centered)');
grid on;

% Create results table
results = table([freq_no_mass; freq_equiv; freq_disk], ...
               [freq_no_mass_uncertainty; freq_equiv_uncertainty; freq_disk_uncertainty], ...
               'VariableNames', {'Frequency_Hz', 'Uncertainty_Hz'}, ...
               'RowNames', {'No_Mass', 'Equivalent_Mass', 'With_Disk'});
disp('Frequency Analysis Results:');
disp(results);

% Analysis of Natural Frequency:
% Case 2 (Equivalent Mass) provides the most accurate measurement of the
% natural frequency since it has the correct mass but no damping effects.
% Case 1 has insufficient mass, and Case 3's frequency is affected by damping.