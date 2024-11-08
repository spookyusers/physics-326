function plotNaturalFrequencyCase(filename, dataFolder, caseName)
    % Construct full file path
    filePath = fullfile(dataFolder, filename);

    % Load data from file with original column headers preserved
    data = readtable(filePath, 'VariableNamingRule', 'preserve');

    % Extract necessary columns using original headers
    time = data.('Time');
    position = data.('Position');

    % Center the position data around zero
    position_centered = position - mean(position);

    % Plot position vs. time
    figure;
    plot(time, position_centered, 'b-', 'LineWidth', 1.5);
    %title(['Case: ', caseName]);
    xlabel('Time (s)');
    ylabel('Position (centered) (m)');
    grid on;
end
