function plotPositionVsTime(dataFolder, voltages)
    % plotPositionVsTime
    % Plots Position vs. Time for selected voltages in the no-damping case.
    %
    % Inputs:
    %   dataFolder - Path to the damping_case2 data folder
    %   voltages   - Array of voltages to plot (e.g., [502, 516, 525, 562])
    
    for i = 1:length(voltages)
        voltage = voltages(i);
        filename = sprintf('%dV.txt', voltage);
        filepath = fullfile(dataFolder, filename);
        
        if exist(filepath, 'file')
            % Read the data with preserved variable names
            data = readtable(filepath, 'VariableNamingRule', 'preserve');
            
            % Extract time and position
            time = data.('Time');
            position = data.('Position');
            
            % Plot Position vs. Time
            figure('Name', sprintf('Position vs. Time for %dV', voltage), 'NumberTitle', 'off');
            plot(time, position, 'b-', 'LineWidth', 1.5);
            xlabel('Time (s)', 'FontSize', 12);
            ylabel('Position (m)', 'FontSize', 12);
            title(sprintf('Position vs. Time for %dV', voltage), 'FontSize', 14);
            grid on;
        else
            warning('File %s not found.', filepath);
        end
    end
end
