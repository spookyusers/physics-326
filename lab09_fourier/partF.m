% Part F: Voice Analysis
clear; close all; clc;

% Set the root path relative to the current working directory
root_path = './data';

% Folders containing time-domain and frequency-domain data
oscill_folder = fullfile(root_path, 'voice_data_oscill');
spect_folder = fullfile(root_path, 'voice_data_spect');

% List of voice samples with their oscillation folder names, spectrum file names, and labels
voice_samples = {
    'voice_low', 'voice_low-spect', 'Low Tone';
    'voice_med', 'voice_medium-spect', 'Medium Tone';
    'voice_high', 'voice_high-spect', 'High Tone';
};

% Loop over each voice sample
for i = 1:size(voice_samples, 1)
    oscill_label = voice_samples{i, 1};   % Oscillation folder name
    spect_file_name = voice_samples{i, 2}; % Spectrum file name
    description = voice_samples{i, 3};     % Description
    
    %% Time-Domain Data Analysis
    % Construct the folder path for the oscilloscope data
    data_folder = fullfile(oscill_folder, oscill_label);

    % Find the CSV file in the data folder
    csv_files = dir(fullfile(data_folder, '*.CSV'));
    if isempty(csv_files)
        csv_files = dir(fullfile(data_folder, '*.csv'));
    end

    if isempty(csv_files)
        warning('No CSV files found in folder: %s', data_folder);
        continue;
    end

    % Read the waveform data
    csv_file = fullfile(data_folder, csv_files(1).name);
    data = readmatrix(csv_file, 'NumHeaderLines', 18);

    % Check if data has enough columns
    if size(data, 2) < 5
        error('Data in file %s does not have the expected number of columns.', csv_file);
    end

    time = data(:, 4);        % Time in seconds
    voltage = data(:, 5);     % Voltage in volts

    % Plot the time-domain waveform
    figure;
    plot(time * 1000, voltage, 'b-');
    xlabel('Time (ms)');
    ylabel('Voltage (V)');
    title(sprintf('Time-Domain Waveform of %s', description));
    grid on;

    %% Frequency-Domain Analysis using FFT
    Ts = time(2) - time(1);    % Sampling interval
    Fs = 1 / Ts;               % Sampling frequency
    N = length(voltage);       % Number of samples

    % Perform FFT
    fft_voltage = fft(voltage);
    fft_voltage = fft_voltage / N;  % Normalize
    freq = (0:N-1)*(Fs/N);          % Frequency vector

    % Only take the positive frequencies (up to Nyquist frequency)
    nyq = floor(N/2);
    freq = freq(1:nyq);
    fft_voltage = fft_voltage(1:nyq);
    magnitude = 2 * abs(fft_voltage);  % Single-sided spectrum

    %% Read SR760 Spectrum Analyzer Data
    % Construct the file path for the SR760 data
    spect_file = fullfile(spect_folder, spect_file_name);
    if isfile(spect_file)
        sr760_data = readmatrix(spect_file, 'FileType', 'text');

        % Extract frequency and magnitude
        sr_freq = sr760_data(:, 1);        % Frequency in Hz
        sr_magnitude = sr760_data(:, 2);   % Magnitude

        % Plot comparison of FFT and SR760 spectra (logarithmic scale)
        figure;
        semilogy(freq, magnitude, 'b-', sr_freq, sr_magnitude, 'r--');
        xlabel('Frequency (Hz)');
        ylabel('Magnitude');
        title(sprintf('Frequency Spectrum of %s', description));
        legend('FFT Spectrum', 'SR760 Spectrum');
        grid on;
        xlim([0, 5000]);  % Frequency range for human voice
    else
        % Plot FFT spectrum only if SR760 data is unavailable
        figure;
        semilogy(freq, magnitude, 'b-');
        xlabel('Frequency (Hz)');
        ylabel('Magnitude');
        title(sprintf('FFT Spectrum of %s', description));
        grid on;
        xlim([0, 5000]);  % Frequency range for human voice
    end
end
