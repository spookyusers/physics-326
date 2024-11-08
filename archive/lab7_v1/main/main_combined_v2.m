% main_week1.m
% Main Script for Processing Forced Oscillation Data (Lab 7 and 8 Analysis)
% Author: Kym Derriman
% Date: 11/3/24

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
            4.95, 5.05, 5.16, 5.26, 5.35];

% Process all voltage files and collect results into a table
results_table = processAllVoltages(voltages, dataFolderPart2);

% Display Results
disp('Part 2: Forced Oscillation Results Table:');
disp(results_table);

% highest amplitude shown at 4.85V with amp = 0.16159, freq = 5.1441

%% Theory vs. Experiment Plots

% Collect experimental data
frequencies_exp = results_table.Frequency;
amplitudes_exp = results_table.Amplitude;
phases_exp = results_table.Phase;
v_max_exp = results_table.Vmax;

% Ensure data is in column vectors
frequencies_exp = frequencies_exp(:);
amplitudes_exp = amplitudes_exp(:);
phases_exp = phases_exp(:);
v_max_exp = v_max_exp(:);

%% Plot Amplitude vs. Angular Frequency with Theoretical Curves
plotAmplitudeVsFrequencyTheoretical(frequencies_exp, amplitudes_exp);

%% Plot Maximum Velocity vs. Angular Frequency with Theoretical Curves
plotVelocityVsFrequencyTheoretical(frequencies_exp, v_max_exp);

%% Plot Phase Difference vs. Angular Frequency with Theoretical Curve
plotPhaseVsFrequencyTheoretical(frequencies_exp, phases_exp);

%% Part E: Improved Estimation Method
% % Define the theoretical model function
% modelFun = @(params, omega) params(1) ./ sqrt((params(2)^2 - omega.^2).^2 + (params(3) .* omega).^2);
% 
% % Initial guesses for [F0_over_m, omega0, gamma]
% initialGuess = [max(amplitudes), 5, 0.5];
% 
% % Perform curve fitting
% params_estimated = lsqcurvefit(modelFun, initialGuess, frequencies, amplitudes);
% 
% % Extract estimated parameters
% F0_over_m_est = params_estimated(1);
% omega0_est = params_estimated(2);
% gamma_est = params_estimated(3);

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

% Process data for Damping Case 1 using the combined function
results_case1 = processVoltageDataCombined(voltages_case1, dataFolderCase1, '');


%% Part G: Forced Oscillation Data Processing for Damping Case 2 (No Plate)
% Voltages and filenames for Damping Case 2
voltages_case2 = [502, 514, 516, 521, 525, 533, 539, 556, 562];
dataFolderCase2 = dataFolderDampingCase2;

% Process data for Damping Case 2 using the combined function with 'NoPlate' prefix
results_case2 = processVoltageDataCombined(voltages_case2, dataFolderCase2, 'NoPlate');

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

% Define masses for each damping case
% Include in analysis when calculating parameters that depend on mass, like
% force amplitude F0 and mass m in summary table

mass_paper_plate = 0.01;    % kg, used in Week 2
mass_large_disc = 0.1;       % kg, assumed for Week 1

mass_total_week1 = 0.5274;   % kg, total mass for Week 1
mass_additional_week1 = mass_total_week1 - mass_large_disc; % kg, base mass for Week 1

mass_total_week2 = mass_additional_week1 + mass_paper_plate;  % kg, total mass for Week 2
mass_no_plate_week2 = mass_total_week2;                      % kg, no plate in Week 2



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


