% diagnosticAnalysis.m
% Script to process all data files and output diagnostic information.

% Clear workspace and close figures
clear; close all; clc;

% Add functions directory to MATLAB path
addpath('functions');

% Define data folder for Part 2
dataFolder = fullfile('data_week1', 'part2');

% List of driving voltages corresponding to different motor frequencies
voltages = [3.18, 4.14, 4.25, 4.35, 4.45, 4.55, 4.65, 4.78, 4.85, ...
            4.95, 5.05, 5.16, 5.26, 5.35, 6.00, 9.50];

% Initialize arrays to store results and issues
n_files = length(voltages);
results_table = [];
issues = [];

% Process each voltage file
for i = 1:n_files
    voltage = voltages(i);
    fprintf('Processing voltage: %.2f V\n', voltage);
    
    % Try to process the file and catch any errors
    try
        [period, amplitude, phase_diff, frequency] = processVoltageFileDiagnostic(voltage, dataFolder);
        
        % Append results to table
        results_table = [results_table; {voltage, period, frequency, amplitude, phase_diff}];
    catch ME
        % Record any errors or warnings
        issues = [issues; {voltage, ME.message}];
    end
end

% Convert results to a table
results_table = cell2table(results_table, 'VariableNames', ...
    {'Voltage', 'Period', 'Frequency', 'Amplitude', 'Phase'});

% Display the results
disp('Results Table:');
disp(results_table);

% Display any issues found
if ~isempty(issues)
    disp('Issues Found:');
    issues_table = cell2table(issues, 'VariableNames', {'Voltage', 'Issue'});
    disp(issues_table);
else
    disp('No issues found during processing.');
end
