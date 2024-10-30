
% V8

% Clear workspace and command window
clear;
clc;

% Define experimental cases and their corresponding trial filenames
cases = {
    'No Disc',       {'clean_Lab7_EvA1.txt', 'clean_Lab7_EvA2.txt', 'clean_Lab7_EvA3.txt'};
    'Equiv Mass',    {'clean_Lab7_EvB1.txt', 'clean_Lab7_EvB2.txt', 'clean_Lab7_EvB3.txt'};
    'With Disc',     {'clean_Lab7_EvC1.txt', 'clean_Lab7_EvC2.txt', 'clean_Lab7_EvC3.txt'}
};

num_cases = size(cases, 1);

% Initialize arrays to store results
mean_periods = zeros(num_cases, 1);
period_errors = zeros(num_cases, 1);
frequencies = zeros(num_cases, 1);
freq_errors = zeros(num_cases, 1);

% Loop through each case
for c = 1:num_cases
    case_name = cases{c, 1};
    trial_files = cases{c, 2};
    num_trials = length(trial_files);
    periods = NaN(num_trials, 1); % Initialize with NaN for handling missing files
    
    fprintf('Processing Case %d/%d: %s\n', c, num_cases, case_name);
    
    % Loop through each trial in the current case
    for i = 1:num_trials
        trial_file = trial_files{i};
        
        if isfile(trial_file)
            try
                % Read data from the trial file
                data = readtable(trial_file);
                
                % Ensure necessary columns exist
                required_columns = {'Time', 'Position', 'Angle2'};
                if ~all(ismember(required_columns, data.Properties.VariableNames))
                    warning('File %s is missing required columns. Skipping this trial.', trial_file);
                    continue;
                end
                
                % Analyze oscillations using the analyzeOscillations function
                [period, ~, ~] = analyzeOscillations(data.Time, ...
                    data.Position - mean(data.Position), ...
                    data.Angle2 - mean(data.Angle2));
                
                periods(i) = period;
                
            catch ME
                warning('Error processing file %s: %s. Skipping this trial.', trial_file, ME.message);
                continue;
            end
        else
            warning('File %s does not exist. Skipping this trial.', trial_file);
            continue;
        end
    end
    
    % Remove NaN values resulting from skipped trials
    valid_periods = periods(~isnan(periods));
    num_valid = length(valid_periods);
    
    if num_valid == 0
        warning('No valid trials found for case "%s". Assigning NaN to results.', case_name);
        mean_periods(c) = NaN;
        period_errors(c) = NaN;
        frequencies(c) = NaN;
        freq_errors(c) = NaN;
    else
        % Calculate mean period and its standard error
        mean_periods(c) = mean(valid_periods);
        period_errors(c) = std(valid_periods) / sqrt(num_valid);
        
        % Calculate frequency and its standard error
        frequencies(c) = 1 / mean_periods(c);
        freq_errors(c) = std(1 ./ valid_periods) / sqrt(num_valid);
    end
end

% Compile results into a table
results = table(mean_periods, period_errors, frequencies, freq_errors, ...
    'VariableNames', {'Period_s', 'Period_Error', 'Frequency_Hz', 'Freq_Error'}, ...
    'RowNames', cases(:,1));

% Display the results
disp('Results from multiple trials:')
disp(results)

% Plot frequency comparison with error bars
figure('Name', 'Frequency Comparison', 'NumberTitle', 'off');
errorbar(1:num_cases, frequencies, freq_errors, 'bo', 'MarkerFaceColor', 'b', 'LineWidth', 1.5);
title('Frequency Comparison Across Experimental Cases');
xticks(1:num_cases);
xticklabels(cases(:,1));
ylabel('Frequency (Hz)');
xlabel('Experimental Case');
grid on;
axis tight;

% Plot example oscillation data from the first valid trial of each case
figure('Name', 'Example Oscillation Data', 'NumberTitle', 'off');
hold on;
colors = {'b', 'r', 'g'};
labels = {};
for c = 1:num_cases
    case_name = cases{c, 1};
    trial_files = cases{c, 2};
    color = colors{c};
    plotted = false;
    
    % Find the first valid trial
    for i = 1:length(trial_files)
        trial_file = trial_files{i};
        if isfile(trial_file)
            try
                data = readtable(trial_file);
                
                % Ensure necessary columns exist
                required_columns = {'Time', 'Position', 'Angle2'};
                if ~all(ismember(required_columns, data.Properties.VariableNames))
                    continue;
                end
                
                % Analyze oscillations to ensure validity
                [period, ~, ~] = analyzeOscillations(data.Time, ...
                    data.Position - mean(data.Position), ...
                    data.Angle2 - mean(data.Angle2));
                
                % Plot the oscillation data
                plot(data.Time, data.Position - mean(data.Position), '-', 'Color', color, 'DisplayName', case_name);
                plotted = true;
                break; % Exit after plotting the first valid trial
            catch
                continue;
            end
        end
    end
    
    if ~plotted
        warning('No valid trials to plot for case "%s".', case_name);
    end
end
hold off;
title('Example Oscillation Data from Each Case');
xlabel('Time (s)');
ylabel('Position (m)');
legend('show', 'Location', 'best');
grid on;