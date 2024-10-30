
% Purpose: Analyze oscillatory behavior of EvA1 (No Mass), B1 (Equivalent Mass), and C1 (With Disc) datasets.


clc; clear; close all;

% Define the list of datasets and their corresponding labels
datasets = {'clean_Lab7_EvA3.txt', 'clean_Lab7_EvB3.txt', 'clean_Lab7_EvC3.txt'};
labels = {'A1 (No Mass / No Disc)', 'B1 (Equivalent Mass)', 'C1 (With Disc)'};

% Initialize arrays to store results
avgPeriods = zeros(length(datasets),1);
periodErrors = zeros(length(datasets),1);
phaseDiffs = zeros(length(datasets),1);
frequencies = zeros(length(datasets),1);

% Create a figure for Position vs. Time plots
figure('Name','Position vs. Time','NumberTitle','off');
hold on;
colors = {'b', 'g', 'r'}; % Colors for different datasets

for i = 1:length(datasets)
    % Import data
    tbl = readtable(datasets{i});
    
    % Extract relevant columns
    Time = tbl.Time;
    Position = tbl.Position;
    Angle2 = tbl.Angle2;

    % Shift Position data by subtracting the mean to center oscillations around zero
    Position_mean = mean(Position);
    Position_shifted = Position - Position_mean;
    
    % Plot Shifted Position vs. Time for visual verification
    plot(Time, Position_shifted, colors{i}, 'DisplayName', labels{i});
    
    % Call the analyzeOscillations function
    [avgPeriod, periodError, phaseDiff] = analyzeOscillations(Time, Position_shifted, Angle2);
    
    % Calculate frequency
    frequency = 1 / avgPeriod;
    
    % Store results
    avgPeriods(i) = avgPeriod;
    periodErrors(i) = periodError;
    phaseDiffs(i) = phaseDiff;
    frequencies(i) = frequency;
    
    % Print results
    fprintf('--------------------------------------------------------------\n');
    fprintf('Oscillation Results for %s:\n', labels{i});
    fprintf('Average Period: %.4f +- %.4f seconds\n', avgPeriod, periodError);
    fprintf('Frequency: %.4f Hertz\n', frequency);
    fprintf('Phase Difference: %.4f radians\n\n', phaseDiff);
end

% Finalize the Position vs. Time plot
xlabel('Time (s)');
ylabel('Shifted Position (m)');
title('Position vs. Time for Different Experimental Cases');
legend('show');
grid on;
hold off;

% Create a summary table for Natural Frequencies and Phase Differences
Results = table(labels', avgPeriods, periodErrors, frequencies, phaseDiffs, ...
    'VariableNames', {'Dataset', 'Average_Period_s', 'Period_Error_s', 'Frequency_Hz', 'Phase_Difference_rad'});
disp('Summary of Oscillation Analysis:');
disp(Results);

%%
% Inspect first few rows of each dataset
tblA1 = readtable('clean_Lab7_EvA1.txt');
disp('First 5 rows of A1:');
disp(tblA1(1:5, :));

tblB1 = readtable('clean_Lab7_EvB1.txt');
disp('First 5 rows of B1:');
disp(tblB1(1:5, :));

tblC1 = readtable('clean_Lab7_EvC1.txt');
disp('First 5 rows of C1:');
disp(tblC1(1:5, :));

