% main_week2.m
% Main Script for Processing Forced Oscillation Data (Lab Week 2 Analysis)
% Author: Kym Derriman
% Date: 11/3/2024

%% Initialization
clear; close all; clc;

% Add functions directory to MATLAB path
addpath('functions_week2');

% Define data folders
dataFolderNaturalFreq = fullfile('data_week2', 'natural_frequency');
dataFolderDampingCase1 = fullfile('data_week2', 'damping_case1');
dataFolderDampingCase2 = fullfile('data_week2', 'damping_case2');

%% Part F: Natural Frequency Analysis
% List of cases and corresponding data files
cases = {'Mass Additional', 'Mass Equivalent No Plate', 'Mass Additional With Plate'};
filenames = {'MassAdditional.txt', 'MassEquivalentNoPlate.txt', 'MassAdditionalWithPlate.txt'};

% Initialize arrays to store results
num_cases = length(cases);
avg_periods = zeros(num_cases, 1);
std_periods = zeros(num_cases, 1);
frequencies = zeros(num_cases, 1);
freq_uncertainties = zeros(num_cases, 1);

% Process each case
for i = 1:num_cases
    [avg_periods(i), std_periods(i), frequencies(i), freq_uncertainties(i)] = ...
        processNaturalFrequencyCase(filenames{i}, dataFolderNaturalFreq);
    
    % Plot position vs. time for each case
    plotNaturalFrequencyCase(filenames{i}, dataFolderNaturalFreq, cases{i});
end

% Create results table
results_natural_freq = table(frequencies, freq_uncertainties, ...
    'VariableNames', {'Frequency_Hz', 'Uncertainty_Hz'}, ...
    'RowNames', cases);

disp('Natural Frequency Analysis Results:');
disp(results_natural_freq);

% For future use, you might select the natural frequency from here
% For example:
% measured_omega0 = mean(frequencies) * 2 * pi; % Convert Hz to rad/s

%% Part F: Forced Oscillation Data Processing for Damping Case 1 (Paper Plate)
% Voltages and filenames for Damping Case 1
voltages_case1 = [478, 492, 501, 504, 506, 507, 510, 513, 515, 516, 520, 524, 525, 527, 530, 538];
dataFolderCase1 = dataFolderDampingCase1;

% Process data for Damping Case 1
results_case1 = processVoltageDataCombined(voltages_case1, dataFolderCase1, '');

%% Part G: Forced Oscillation Data Processing for Damping Case 2 (No Plate)
% Voltages and filenames for Damping Case 2
voltages_case2 = [502, 514, 516, 521, 525, 533, 539, 556, 562];
dataFolderCase2 = dataFolderDampingCase2;

% Process data for Damping Case 2
results_case2 = processVoltageDataCombined(voltages_case2, dataFolderCase2, 'NoPlate');

%% Analysis and Plotting

% Assign data to structures
data_case1.Frequency = results_case1.Frequency_rad_s;
data_case1.Amplitude = results_case1.Amplitude_m;
data_case1.AngleAmplitude = results_case1.AngleAmplitude_rad;
data_case1.Phase = results_case1.Phase_rad;
data_case1.Vmax = results_case1.Vmax_m_s;

data_case2.Frequency = results_case2.Frequency_rad_s;
data_case2.Amplitude = results_case2.Amplitude_m;
data_case2.AngleAmplitude = results_case2.AngleAmplitude_rad;
data_case2.Phase = results_case2.Phase_rad;
data_case2.Vmax = results_case2.Vmax_m_s;

% Estimate parameters for each case
[data_case1.omega0, data_case1.gamma] = estimateParameters(data_case1.Frequency, data_case1.Amplitude);
[data_case2.omega0, data_case2.gamma] = estimateParameters(data_case2.Frequency, data_case2.Amplitude);

% % Display estimated parameters
% disp('Estimated Parameters for Case 1:');
% disp(['omega0 = ', num2str(data_case1.omega0), ' rad/s']);
% disp(['gamma = ', num2str(data_case1.gamma), ' rad/s']);
% 
% disp('Estimated Parameters for Case 2:');
% disp(['omega0 = ', num2str(data_case2.omega0), ' rad/s']);
% disp(['gamma = ', num2str(data_case2.gamma), ' rad/s']);

%% Part H: Compare results of Damping Cases

% Mass measurements
mass_plate = 0.01; % kg, mass of paper plate
mass_baseline = 0.5264; % kg, mass without plate

% Mass for each case
mass_case1 = mass_baseline + mass_plate; % With paper plate
mass_case2 = mass_baseline;              % Without plate

% Calculate force amplitude F0 for each case
F0_case1 = calculateForceAmplitude(data_case1.AngleAmplitude);
F0_case2 = calculateForceAmplitude(data_case2.AngleAmplitude);

% Create summary table
summary_table = table([F0_case1; F0_case2], [mass_case1; mass_case2], [data_case1.omega0; data_case2.omega0], [data_case1.gamma; data_case2.gamma], ...
    'VariableNames', {'F0', 'Mass', 'Omega0', 'Gamma'}, ...
    'RowNames', {'Paper Plate', 'No Plate'});

disp('Summary Table:');
disp(summary_table);

%% Parts I, J, K

% Calculate normalized frequencies for each case
omega_bar_case1 = data_case1.Frequency / data_case1.omega0;
omega_bar_case2 = data_case2.Frequency / data_case2.omega0;

% Calculate normalized amplitudes
r_case1 = data_case1.Amplitude / max(data_case1.Amplitude);
r_case2 = data_case2.Amplitude / max(data_case2.Amplitude);

% Calculate normalized phase differences
phi_norm_case1 = data_case1.Phase / pi;
phi_norm_case2 = data_case2.Phase / pi;

% Calculate normalized velocity amplitudes
g_case1 = data_case1.Vmax / max(data_case1.Vmax);
g_case2 = data_case2.Vmax / max(data_case2.Vmax);

% Calculate damping ratios for each case
zeta_case1 = data_case1.gamma / (2 * data_case1.omega0);
zeta_case2 = data_case2.gamma / (2 * data_case2.omega0);

% Define omega_bar range based on your data
min_omega_bar = min([omega_bar_case1; omega_bar_case2]) * 0.95;
max_omega_bar = max([omega_bar_case1; omega_bar_case2]) * 1.05;
omega_bar = linspace(min_omega_bar, max_omega_bar, 500);

% Theoretical amplitude for each case
theoretical_r_case1 = 1 ./ sqrt((1 - omega_bar.^2).^2 + (2 * zeta_case1 * omega_bar).^2);
theoretical_r_case2 = 1 ./ sqrt((1 - omega_bar.^2).^2 + (2 * zeta_case2 * omega_bar).^2);

% Normalize theoretical amplitudes
theoretical_r_case1_normalized = 2 * zeta_case1 * theoretical_r_case1;
theoretical_r_case2_normalized = 2 * zeta_case2 * theoretical_r_case2;

% Plot normalized amplitude vs. normalized frequency
figure;
hold on;
% Experimental data
plot(omega_bar_case1, r_case1, 'o', 'DisplayName', 'Experimental Case 1');
plot(omega_bar_case2, r_case2, 's', 'DisplayName', 'Experimental Case 2');
% Theoretical curves
plot(omega_bar, theoretical_r_case1_normalized, '-', 'DisplayName', 'Theoretical Case 1');
plot(omega_bar, theoretical_r_case2_normalized, '--', 'DisplayName', 'Theoretical Case 2');
xlabel('Normalized Frequency \omega / \omega_0');
ylabel('Normalized Amplitude r(\omega)');
title('Normalized Amplitude vs. Normalized Frequency');
legend('Location', 'Best');
grid on;
hold off;

% Part J: Plot normalized phase difference vs. normalized frequency

% Theoretical phase difference for each case
theoretical_phi_case1 = atan2(2 * zeta_case1 * omega_bar, 1 - omega_bar.^2);
theoretical_phi_case2 = atan2(2 * zeta_case2 * omega_bar, 1 - omega_bar.^2);

% Normalize theoretical phase differences
theoretical_phi_case1_normalized = theoretical_phi_case1 / pi;
theoretical_phi_case2_normalized = theoretical_phi_case2 / pi;

% Plot normalized phase difference
figure;
hold on;
plot(omega_bar_case1, phi_norm_case1, 'o', 'DisplayName', 'Experimental Case 1');
plot(omega_bar_case2, phi_norm_case2, 's', 'DisplayName', 'Experimental Case 2');
plot(omega_bar, theoretical_phi_case1_normalized, '-', 'DisplayName', 'Theoretical Case 1');
plot(omega_bar, theoretical_phi_case2_normalized, '--', 'DisplayName', 'Theoretical Case 2');
xlabel('Normalized Frequency \omega / \omega_0');
ylabel('Normalized Phase Difference \phi / \pi');
title('Normalized Phase Difference vs. Normalized Frequency');
legend('Location', 'Best');
grid on;
hold off;

% Part K: Plot normalized velocity amplitude vs. normalized frequency

% Theoretical normalized velocity amplitude
theoretical_g_case1 = omega_bar .* theoretical_r_case1_normalized;
theoretical_g_case2 = omega_bar .* theoretical_r_case2_normalized;

% Normalize theoretical velocity amplitudes
theoretical_g_case1_normalized = theoretical_g_case1 / max(theoretical_g_case1);
theoretical_g_case2_normalized = theoretical_g_case2 / max(theoretical_g_case2);

% Plot normalized velocity amplitude
figure;
hold on;
plot(omega_bar_case1, g_case1, 'o', 'DisplayName', 'Experimental Case 1');
plot(omega_bar_case2, g_case2, 's', 'DisplayName', 'Experimental Case 2');
plot(omega_bar, theoretical_g_case1_normalized, '-', 'DisplayName', 'Theoretical Case 1');
plot(omega_bar, theoretical_g_case2_normalized, '--', 'DisplayName', 'Theoretical Case 2');
xlabel('Normalized Frequency \omega / \omega_0');
ylabel('Normalized Velocity Amplitude g(\omega)');
title('Normalized Velocity Amplitude vs. Normalized Frequency');
legend('Location', 'Best');
grid on;
hold off;
