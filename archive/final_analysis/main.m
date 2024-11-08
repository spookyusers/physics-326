% main.m
% Combined Main Script for Processing Oscillation Data (Final Analysis)
% Author: Kym Derriman
% Date: [Current Date]

%% Initialization
clear; close all; clc;

% Add functions directory to MATLAB path
addpath('functions');

% Define data folder
dataFolder = 'data'; % Combined data folder

%% Part 1: Natural Frequency Analysis
% List of cases and corresponding data files
cases = {'No Mass', 'Equivalent Mass', 'With Disk', 'Mass Additional', 'Mass Equivalent No Plate', 'Mass Additional With Plate'};
filenames = {'clean_Lab7_EvB1.txt', 'clean_Lab7_EvA1.txt', 'clean_Lab7_EvC1.txt', 'MassAdditional.txt', 'MassEquivalentNoPlate.txt', 'MassAdditionalWithPlate.txt'};

% Initialize arrays to store results
num_cases = length(cases);
avg_periods = zeros(num_cases, 1);
std_periods = zeros(num_cases, 1);
frequencies = zeros(num_cases, 1);
freq_uncertainties = zeros(num_cases, 1);

% Process each case
for i = 1:num_cases
    [avg_periods(i), std_periods(i), frequencies(i), freq_uncertainties(i)] = ...
        processNaturalFrequencyCase(filenames{i}, dataFolder);

    % Plot position vs. time for each case
    plotNaturalFrequencyCase(filenames{i}, dataFolder, cases{i});
end

% Create results table for Part 1
results_part1 = table(frequencies, freq_uncertainties, ...
    'VariableNames', {'Frequency_Hz', 'Uncertainty_Hz'}, ...
    'RowNames', cases);

disp('Part 1: Frequency Analysis Results:');
disp(results_part1);

%% Part 2: Forced Oscillation Data Processing
% Voltages and data files for the different damping cases
voltages_case1 = [478, 492, 501, 504, 506, 507, 510, 513, 515, 516, 520, 524, 525, 527, 530, 538]; % Damping Case 1
voltages_case2 = [502, 514, 516, 521, 525, 533, 539, 556, 562]; % Damping Case 2

% Process data for Damping Case 1
results_case1 = processVoltageDataCombined(voltages_case1, dataFolder, '');

% Process data for Damping Case 2
results_case2 = processVoltageDataCombined(voltages_case2, dataFolder, 'NoPlate');

%% Analysis and Plotting

% Assign data to structures for each case
data_case1 = struct('Frequency', results_case1.Frequency_rad_s, ...
                    'Amplitude', results_case1.Amplitude_m, ...
                    'AngleAmplitude', results_case1.AngleAmplitude_rad, ...
                    'Phase', results_case1.Phase_rad, ...
                    'Vmax', results_case1.Vmax_m_s);

data_case2 = struct('Frequency', results_case2.Frequency_rad_s, ...
                    'Amplitude', results_case2.Amplitude_m, ...
                    'AngleAmplitude', results_case2.AngleAmplitude_rad, ...
                    'Phase', results_case2.Phase_rad, ...
                    'Vmax', results_case2.Vmax_m_s);

% Estimate parameters for each case
[data_case1.omega0, data_case1.gamma] = estimateParameters(data_case1.Frequency, data_case1.Amplitude);
[data_case2.omega0, data_case2.gamma] = estimateParameters(data_case2.Frequency, data_case2.Amplitude);

% Display estimated parameters
disp('Estimated Parameters for Case 1:');
disp(['omega0 = ', num2str(data_case1.omega0), ' rad/s']);
disp(['gamma = ', num2str(data_case1.gamma), ' rad/s']);

disp('Estimated Parameters for Case 2:');
disp(['omega0 = ', num2str(data_case2.omega0), ' rad/s']);
disp(['gamma = ', num2str(data_case2.gamma), ' rad/s']);

%% Plotting Normalized Amplitude vs. Normalized Frequency
plotNormalizedAmplitude(data_case1, data_case2);

%% Plotting Normalized Phase Difference vs. Normalized Frequency
plotNormalizedPhaseDifference(data_case1, data_case2);

%% Plotting Normalized Velocity Amplitude vs. Normalized Frequency
plotNormalizedVelocityAmplitude(data_case1, data_case2);
