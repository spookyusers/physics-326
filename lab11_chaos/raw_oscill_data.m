% Script: Fix and Plot Oscilloscope Data (ALLxxxx folders)
clear; clc; close all;

% Parent folder containing ALLxxxx subfolders
dataFolder = './oscill_data/';
subfolders = dir(fullfile(dataFolder, 'ALL*')); % Match ALL0000, ALL0001, etc.

% Initialize storage
V0_list = [];
raw_data = {};

% Loop through each ALLxxxx subfolder
for i = 1:length(subfolders)
    folderName = subfolders(i).name;
    folderPath = fullfile(dataFolder, folderName);
    
    % File paths for CH1 and CH2 data
    file_CH1 = fullfile(folderPath, sprintf('F%04dCH1.CSV', i-1));
    file_CH2 = fullfile(folderPath, sprintf('F%04dCH2.CSV', i-1));
    
    % Check if files exist
    if ~isfile(file_CH1) || ~isfile(file_CH2)
        fprintf('Missing files in folder: %s\n', folderName);
        continue;
    end

    % Read CH1 and CH2, skipping first 3 columns
    try
        % Use 'readmatrix' and select columns 4 (time) and 5 (voltage)
        data_CH1 = readmatrix(file_CH1, 'NumHeaderLines', 18, 'OutputType', 'double');
        data_CH2 = readmatrix(file_CH2, 'NumHeaderLines', 18, 'OutputType', 'double');
        
        time = data_CH1(:, 4); % Time column
        Vr = data_CH1(:, 5);   % Response voltage
        V0 = data_CH2(:, 5);   % Input voltage

        % Check for valid data
        if any(isnan(time)) || any(isnan(Vr)) || any(isnan(V0))
            fprintf('Invalid numeric data in folder: %s\n', folderName);
            continue;
        end

        % Store valid data
        V0_list = [V0_list; max(abs(V0))]; % Approximate amplitude of V0
        raw_data{end+1} = {time, Vr, V0};
    catch ME
        fprintf('Error processing folder: %s\n', folderName);
        fprintf('Error message: %s\n', ME.message);
    end
end

% Diagnostics: Display all detected V0 amplitudes
disp('Detected V0 Amplitudes:');
disp(V0_list);

% Plotting the raw voltage data
figure('Position', [100, 100, 1000, 600]);
hold on;
for k = 1:length(raw_data)
    time = raw_data{k}{1};
    Vr = raw_data{k}{2};
    offset = k * 1; % Offset to separate plots visually
    plot(time, Vr + offset, 'DisplayName', sprintf('V_0 = %.3f V', V0_list(k)));
end
title('Raw Voltage Response (Vr) for Different V_0');
xlabel('Time (s)');
ylabel('Voltage (V, Offset for Clarity)');
legend show;
grid on;
