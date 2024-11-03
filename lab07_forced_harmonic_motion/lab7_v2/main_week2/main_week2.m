% main_week2.m
% Main Script for Processing Forced Oscillation Data (Lab Week 2 Analysis)
% Author: Kym Derriman
% Date: 11/3/2024

%% Initialization
clear; close all; clc;

% Add functions directory to MATLAB path
addpath('functions');

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

%% Part F: Forced Oscillation Data Processing for Damping Case 1 (Paper Plate)
% Voltages and filenames for Damping Case 1
voltages_case1 = [478, 492, 501, 504, 506, 507, 510, 513, 515, 516, 520, 524, 525, 527, 530, 538];
dataFolderCase1 = dataFolderDampingCase1;

% Process data for Damping Case 1
results_case1 = processVoltageDataCombined(voltages_case1, dataFolderCase1);

%% Part G: Forced Oscillation Data Processing for Damping Case 2 (No Plate)
% Voltages and filenames for Damping Case 2
voltages_case2 = [502, 514, 516, 521, 525, 533, 539, 556, 562];
dataFolderCase2 = dataFolderDampingCase2;

% Process data for Damping Case 2
results_case2 = processVoltageDataCombined(voltages_case2, dataFolderCase2);

%% Analysis and Plotting

% Estimate parameters for each case
[data_case1.omega0, data_case1.gamma] = estimateParameters(results_case1.Frequency, results_case1.Amplitude);
[data_case2.omega0, data_case2.gamma] = estimateParameters(results_case2.Frequency, results_case2.Amplitude);

% Assign data to structures
data_case1.Frequency = results_case1.Frequency;
data_case1.Amplitude = results_case1.Amplitude;
data_case1.Phase = results_case1.Phase;
data_case1.Vmax = results_case1.Vmax;

data_case2.Frequency = results_case2.Frequency;
data_case2.Amplitude = results_case2.Amplitude;
data_case2.Phase = results_case2.Phase;
data_case2.Vmax = results_case2.Vmax;

% Plot Normalized Amplitude vs. Normalized Frequency
plotNormalizedAmplitude(data_case1, data_case2);

% Plot Normalized Phase Difference vs. Normalized Frequency
plotNormalizedPhaseDifference(data_case1, data_case2);

% Plot Normalized Velocity Amplitude vs. Normalized Frequency
plotNormalizedVelocityAmplitude(data_case1, data_case2);


%% Task G: Analysis of Anharmonicity

% Define representative voltages to analyze (choose a range around resonance)
representative_voltages = [502, 516, 525, 562]; % Adjust as needed

% Plot Position vs. Time for selected voltages in no-damping case
plotPositionVsTimeNoDamping(dataFolderDampingCase2, representative_voltages);

% After plotting, manually inspect the figures to identify anharmonic behavior
% and document your observations.

% Task G Question

% Analyze anharmonic motions in the no-damping case
% show position vs time plots where oscill's not harmonic
% discuss possible reasons, like non-linear effects due to large amplitudes
% or limitations of exp setup

%% Mass measurements
% Include in analysis when calculating parameters that depend on mass, like
% force amplitude F0 and mass m in summary table
mass_plate = 0.01; %kg
mass_total = 0.5274; %kg
mass_additional = mass_total - mass_plate; %kg
%% Diagnostic visualization, bad data file 4.68V
% data = readtable('data_week2/damping_case1/468V.txt', 'VariableNamingRule', 'preserve');
% time = data.('Time');
% position = data.('Position');
% angle = data.('Angle 2');
% 
% figure;
% subplot(2,1,1);
% plot(time, position);
% xlabel('Time (s)');
% ylabel('Position (m)');
% title('Position vs. Time for 468V');
% 
% subplot(2,1,2);
% plot(time, angle);
% xlabel('Time (s)');
% ylabel('Angle (rad)');
% title('Angle vs. Time for 468V');


