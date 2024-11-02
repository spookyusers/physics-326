% main.m
% Main Script for Processing Forced Oscillation Data (Lab 7 and 8 Analysis)
% Author: Kym Derriman
% Date: [Insert Date]

%% Initialization
% Clear workspace and close all figures
clear; close all; clc;

% Add functions directory to MATLAB path
addpath('functions');

% Define data folders
dataFolderPart1 = fullfile('data_week1', 'part1');
dataFolderPart2 = fullfile('data_week1', 'part2');

%% Part 1: Natural Frequency Analysis
% List of cases and corresponding data files
cases = {'No Mass', 'Equivalent Mass', 'With Disk'};
filenames = {'clean_Lab7_EvB1.txt', 'clean_Lab7_EvA1.txt', 'clean_Lab7_EvC1.txt'};

% Initialize arrays to store results
num_cases = length(cases);
avg_periods = zeros(num_cases, 1);
std_periods = zeros(num_cases, 1);
frequencies = zeros(num_cases, 1);
freq_uncertainties = zeros(num_cases, 1);

% Process each case
for i = 1:num_cases
    [avg_periods(i), std_periods(i), frequencies(i), freq_uncertainties(i)] = ...
        processNaturalFrequencyCase(filenames{i}, dataFolderPart1);
    
    % Plot position vs. time for each case
    plotNaturalFrequencyCase(filenames{i}, dataFolderPart1, cases{i});
end

% Create results table
results_part1 = table(frequencies, freq_uncertainties, ...
    'VariableNames', {'Frequency_Hz', 'Uncertainty_Hz'}, ...
    'RowNames', {'No_Mass', 'Equivalent_Mass', 'With_Disk'});

disp('Part 1: Frequency Analysis Results:');
disp(results_part1);

% Analysis of Natural Frequency:
% Case 2 (Equivalent Mass) provides the most accurate measurement of the
% natural frequency since it has the correct mass but minimal damping effects.

%% Part 2: Forced Oscillation Data Processing
% List of driving voltages corresponding to different motor frequencies
voltages = [3.18, 4.14, 4.25, 4.35, 4.45, 4.55, 4.65, 4.78, 4.85, ...
            4.95, 5.05, 5.16, 5.26, 5.35, 6.00, 9.50];

%% Data Processing
% Process all voltage files and collect results into a table
results_table = processAllVoltages(voltages, dataFolderPart2);

%% Display Results
disp('Part 2: Forced Oscillation Results Table:');
disp(results_table);

%% Plotting
% Plot Amplitude vs. Angular Frequency
plotAmplitudeVsFrequency(results_table.Frequency, results_table.Amplitude);

% Plot Maximum Velocity vs. Angular Frequency
plotVelocityVsFrequency(results_table.Frequency, results_table.Vmax);
