% plotNaturalFrequencyCase.m
%
% Plots the position vs. time for a natural frequency case.
%
% Inputs:
%   filename   - Name of the data file for the case
%   dataFolder - Folder where the data files are located
%   caseName   - Name of the case (e.g., 'No Mass', 'Equivalent Mass')

function plotNaturalFrequencyCase(filename, dataFolder, caseName)
    % Construct full file path
    filePath = fullfile(dataFolder, filename);

    % Load data from file
    data = readtable(filePath);

    % Extract necessary columns
    time = data.Time;
    position = data.Position;

    % Center the position data around zero
    position_centered = position - mean(position);

    % Plot position vs. time
    figure;
    plot(time, position_centered, 'b-', 'LineWidth', 1.5);
    title(['Case: ', caseName]);
    xlabel('Time (s)');
    ylabel('Position (centered) (m)');
    grid on;
end