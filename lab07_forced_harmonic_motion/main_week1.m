% main_week1.m
% Main Script for Processing Forced Oscillation Data (Lab 7 and 8 Analysis)
% Author: Kym Derriman
% Date: 11/6/2024

%% Initialization
% Clear workspace and close all figures
clear; close all; clc;

% Add functions directory to MATLAB path
addpath('functions_week1');

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

% Create results table for Part 1
results_part1 = table(frequencies, freq_uncertainties, ...
    'VariableNames', {'Frequency_Hz', 'Uncertainty_Hz'}, ...
    'RowNames', {'No_Mass', 'Equivalent_Mass', 'With_Disk'});

disp('Part 1: Frequency Analysis Results:');
disp(results_part1);

%% Part 2: Forced Oscillation Data Processing
% List of driving voltages corresponding to different motor frequencies
voltages = [3.18, 4.14, 4.25, 4.35, 4.45, 4.55, 4.65, 4.78, 4.85, ...
            4.95, 5.05, 5.16, 5.26, 5.35];

% Process all voltage files and collect results into a table
results_table = processAllVoltages(voltages, dataFolderPart2);

% Display Results
disp('Part 2: Forced Oscillation Results Table:');
disp(results_table);

% Show highest amplitude frequency
[~, idx] = max(results_table.Amplitude_m); % find index from table
highest_amp_omega = results_table.Omega_rad_per_s(idx);
disp(['The angular frequency with the highest amplitude is: ', ...
    num2str(highest_amp_omega), ' rad/s']);
% To get frequency in Hz
highest_amp_frequency_hz = highest_amp_omega / (2 * pi);
disp(['Which corresponds to a frequency of: ', ...
    num2str(highest_amp_frequency_hz), ' Hz']);

%% Theory vs. Experiment Plots

% Collect experimental data for plotting

% Extract data from results_table
omega_exp = results_table.Omega_rad_per_s;   % Angular frequencies in rad/s
amplitudes_exp = results_table.Amplitude_m;  % Amplitudes in meters
phases_exp = results_table.Phase_rad;        % Phases in radians
v_max_exp = results_table.Vmax_m_per_s;      % Max velocities in m/s

% Ensure data is in column vectors
omega_exp = omega_exp(:);
amplitudes_exp = amplitudes_exp(:);
phases_exp = phases_exp(:);
v_max_exp = v_max_exp(:);

% Determine omega0 using maximum amplitude
[~, idx_max_amp] = max(amplitudes_exp);
omega0 = omega_exp(idx_max_amp);  % Resonance angular frequency


%% Plot Amplitude vs. Angular Frequency with Theoretical Curves
plotAmplitudeVsFrequencyTheoretical(omega_exp, amplitudes_exp);

%% Plot Maximum Velocity vs. Angular Frequency with Theoretical Curves
plotVelocityVsFrequencyTheoretical(omega_exp, v_max_exp);

%% Plot Phase Difference vs. Angular Frequency with Theoretical Curve
plotPhaseVsFrequencyTheoretical(omega_exp, phases_exp, omega0);

