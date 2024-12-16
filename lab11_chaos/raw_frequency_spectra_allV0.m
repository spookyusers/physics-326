% Script: Raw Frequency Spectra Overlay for All V0
clear; clc; close all;

% Folder containing spectrum files
dataFolder = './spectro_data/';

% Get a list of all relevant files
fileList = dir(fullfile(dataFolder, 'Spect_*'));

% Initialize storage for V0 values
V0_list = [];
spectra = {};

% Loop through each spectrum file
for i = 1:length(fileList)
    % Extract the filename
    fileName = fileList(i).name;
    filePath = fullfile(dataFolder, fileName);

    % Parse V0 amplitude from filename
    V0_match_1dot = regexp(fileName, 'Spect_1dot(\d+)V', 'tokens'); % Spect_1dotXXXV
    V0_match_dot = regexp(fileName, 'Spect_dot(\d+)V', 'tokens');   % Spect_dotXXXV

    if ~isempty(V0_match_1dot)
        V0_str = V0_match_1dot{1}{1};
        V0_amp = str2double(['1.' V0_str]); % 1dot1350 → 1.350 V
    elseif ~isempty(V0_match_dot)
        V0_str = V0_match_dot{1}{1};
        V0_amp = str2double(['0.' V0_str]); % dot450 → 0.450 V
    else
        fprintf('Could not parse V0 from file: %s\n', fileName);
        continue;
    end
    
    % Read spectrum data
    data = readmatrix(filePath);
    if isempty(data)
        fprintf('No data in file: %s\n', fileName);
        continue;
    end
    
    % Store V0 and spectra for plotting
    V0_list = [V0_list; V0_amp];
    spectra{end+1} = data;
end

% Sort files by V0 for consistent plotting
[V0_sorted, sort_idx] = sort(V0_list);
spectra = spectra(sort_idx);

% Plot Raw Frequency Spectra
figure('Position', [100, 100, 1200, 800]);
hold on;

% Use a color map to differentiate spectra
colors = parula(length(spectra));

for i = 1:length(spectra)
    frequency = spectra{i}(:, 1); % Frequency column
    amplitude = spectra{i}(:, 2); % Amplitude column
    
    % Plot each spectrum with an offset for clarity
    plot(frequency, amplitude + i*10, 'Color', colors(i, :), 'LineWidth', 1.5); 
end

title('Raw Frequency Spectra for All V_0');
xlabel('Frequency (Hz)');
ylabel('Amplitude (dB, Offset for Clarity)');
legend(arrayfun(@(v) sprintf('V_0 = %.3f V', v), V0_sorted, 'UniformOutput', false), ...
    'Location', 'northeastoutside');
grid on;
hold off;
