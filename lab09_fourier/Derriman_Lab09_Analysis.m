% Combined MATLAB Code for Lab Parts A–F

% Initialize the environment
clc; clear; close all;

% Set the root path relative to the current working directory
root_path = './data';

%% Part A: Square Wave Synthesis
% Synthesizes a square wave using Fourier series and plots the
% approximations with increasing numbers of harmonics.

% Define parameters
T_A = 1;                          % Period (seconds)
t_A = -T_A/2:0.001:T_A/2;         % Time vector
N_values_A = [1, 3, 5, 7, 9];     % Number of harmonics to include

% Initialize array to store partial sums
y_sums_A = zeros(length(N_values_A), length(t_A));

% Compute Fourier series approximation for each N
for idx = 1:length(N_values_A)
    N = N_values_A(idx);
    y = zeros(size(t_A));
    for n = 1:2:N               % Sum over odd harmonics
        Bn = 4/(n*pi);          % Fourier coefficient for square wave
        y = y + Bn * sin(2*pi*n*t_A/T_A);
    end
    y_sums_A(idx, :) = y;
end

% Plotting the harmonic sums
figure;
plot(t_A, y_sums_A(1,:), 'b-', 'LineWidth', 1.5); hold on;
plot(t_A, y_sums_A(2,:), 'r--', 'LineWidth', 1.5);
plot(t_A, y_sums_A(3,:), 'g-.', 'LineWidth', 1.5);
plot(t_A, y_sums_A(4,:), 'k:', 'LineWidth', 1.5);
plot(t_A, y_sums_A(5,:), 'm-', 'LineWidth', 1.5);
grid on;
legend('N=1', 'N=3', 'N=5', 'N=7', 'N=9');
xlabel('Time (s)');
ylabel('Amplitude');
title('Square Wave Synthesis with Increasing Number of Harmonics');

%% Part B: Sawtooth Wave Synthesis
% Synthesizes a sawtooth wave using Fourier series and compares
% the approximation to the exact wave.

% Define parameters
T_B = 1;                          % Period (seconds)
t_B = -T_B/2:0.001:T_B/2;         % Time vector
N_B = 1:5;                        % Number of harmonics

% Exact sawtooth wave
f_exact_B = 2*(t_B/T_B);

% Fourier series approximation
f_fourier_B = zeros(size(t_B));
for n = N_B
    Bn = (-2*(-1)^n)/(n*pi);    % Fourier coefficient for sawtooth wave
    f_fourier_B = f_fourier_B + Bn * sin(2*pi*n*t_B/T_B);
end

% Plotting the exact and approximated sawtooth wave
figure;
plot(t_B, f_exact_B, 'k-', 'LineWidth', 1.5, 'DisplayName', 'Exact Sawtooth');
hold on;
plot(t_B, f_fourier_B, 'r--', 'LineWidth', 1.5, 'DisplayName', 'Fourier Approximation (n=5)');
grid on;
xlabel('Time (s)');
ylabel('Amplitude');
title('Sawtooth Wave: Exact vs Fourier Series Approximation');
legend('Location', 'best');

%% Part D: Square and Triangular Wave Analysis
% Analyzes the frequency components of square and triangular waves
% using FFT and compares them with theoretical Fourier coefficients.

% Define parameters
T_D = 1/1000;                % Period for 1 kHz wave
Fs_D = 100000;               % Sampling frequency (100 kHz)
t_D = 0:1/Fs_D:2*T_D;        % Time vector covering two periods

% Square Wave Analysis
square_wave_D = square(2*pi*1000*t_D);
N_D = length(square_wave_D);
fft_square_D = fft(square_wave_D)/N_D;
freq_D = (0:N_D-1)*(Fs_D/N_D);
nyq_D = floor(N_D/2);
freq_D = freq_D(1:nyq_D);
mag_square_D = 2*abs(fft_square_D(1:nyq_D));

% Theoretical Fourier coefficients for square wave (odd harmonics)
n_harmonics_D = 20;
n_values_D = 1:2:(2*n_harmonics_D-1);
An_D = 4./(n_values_D*pi);
harmonic_freqs_D = 1000 * n_values_D;  % in Hz
[~, indices_D] = arrayfun(@(f) min(abs(freq_D - f)), harmonic_freqs_D);
fft_magnitudes_square_D = mag_square_D(indices_D);

% Plot time-domain square wave
figure;
subplot(2,1,1);
plot(t_D*1000, square_wave_D, 'b-');
xlabel('Time (ms)');
ylabel('Amplitude');
title('Square Wave - Time Domain');
grid on;

% Plot FFT magnitudes and theoretical coefficients for square wave
subplot(2,1,2);
stem(freq_D(indices_D)/1000, fft_magnitudes_square_D, 'b', 'LineWidth', 1.5); hold on;
stem(freq_D(indices_D)/1000, An_D, 'r--', 'LineWidth', 1.5);
xlabel('Frequency (kHz)');
ylabel('Magnitude');
title('Square Wave: FFT Magnitudes vs Theoretical Fourier Coefficients');
legend('FFT Magnitudes', 'Theoretical Coefficients');
grid on;

% Triangular Wave Analysis
triangular_wave_D = sawtooth(2*pi*1000*t_D, 0.5);  % Symmetric triangle wave
fft_triangle_D = fft(triangular_wave_D)/N_D;
mag_triangle_D = 2*abs(fft_triangle_D(1:nyq_D));
Bn_D = (8./(pi^2)) .* ((-1).^((n_values_D-1)/2)) ./ (n_values_D.^2);
fft_magnitudes_triangle_D = mag_triangle_D(indices_D);

% Plot time-domain triangular wave
figure;
subplot(2,1,1);
plot(t_D*1000, triangular_wave_D, 'b-');
xlabel('Time (ms)');
ylabel('Amplitude');
title('Triangular Wave - Time Domain');
grid on;

% Plot FFT magnitudes and theoretical coefficients for triangular wave
subplot(2,1,2);
stem(freq_D(indices_D)/1000, fft_magnitudes_triangle_D, 'b', 'LineWidth', 1.5); hold on;
stem(freq_D(indices_D)/1000, abs(Bn_D), 'r--', 'LineWidth', 1.5);
xlabel('Frequency (kHz)');
ylabel('Magnitude');
title('Triangular Wave: FFT Magnitudes vs Theoretical Fourier Coefficients');
legend('FFT Magnitudes', 'Theoretical Coefficients');
grid on;

%% Part E: Tuning Fork Analysis
% Analyzes tuning fork data from the oscilloscope and SR760 spectrum analyzer.

% Folders containing data
oscill_folder_E = fullfile(root_path, 'tuning_fork_data_oscill');
spect_folder_E = fullfile(root_path, 'tuning_fork_data_spect');

% List of tuning forks
tuning_forks_E = {
    '261-62', 'C4', 261.62;
    '329-63', 'E4', 329.63;
    '392-00', 'G4', 392.00;
};

% Loop over each tuning fork
for i = 1:size(tuning_forks_E, 1)
    freq_label_E = tuning_forks_E{i, 1};
    note_E = tuning_forks_E{i, 2};

    % Time-Domain Data Analysis
    data_folder_E = fullfile(oscill_folder_E, freq_label_E);
    csv_files_E = dir(fullfile(data_folder_E, '*.CSV'));
    if isempty(csv_files_E)
        csv_files_E = dir(fullfile(data_folder_E, '*.csv'));
    end
    if isempty(csv_files_E)
        warning('No CSV files found in folder: %s', data_folder_E);
        continue;
    end
    csv_file_E = fullfile(data_folder_E, csv_files_E(1).name);
    data_E = readmatrix(csv_file_E, 'NumHeaderLines', 18);
    time_E = data_E(:, 4);        % Time in seconds
    voltage_E = data_E(:, 5);     % Voltage in volts

    % Plot the time-domain waveform
    figure;
    plot(time_E * 1000, voltage_E, 'b-');
    xlabel('Time (ms)');
    ylabel('Voltage (V)');
    title(sprintf('Time-Domain Waveform of %s Tuning Fork (%s Hz)', note_E, freq_label_E));
    grid on;

    % Frequency-Domain Analysis using FFT
    Ts_E = time_E(2) - time_E(1);
    Fs_E = 1 / Ts_E;
    N_E = length(voltage_E);
    fft_voltage_E = fft(voltage_E)/N_E;
    freq_E = (0:N_E-1)*(Fs_E/N_E);
    nyq_E = floor(N_E/2);
    freq_E = freq_E(1:nyq_E);
    magnitude_E = 2 * abs(fft_voltage_E(1:nyq_E));

    % Read SR760 Spectrum Analyzer Data
    spect_file_E = fullfile(spect_folder_E, [freq_label_E, '-spect']);
    if isfile(spect_file_E)
        sr760_data_E = readmatrix(spect_file_E, 'FileType', 'text');
        sr_freq_E = sr760_data_E(:, 1);
        sr_magnitude_E = sr760_data_E(:, 2);

        % Plot comparison of FFT and SR760 spectra
        figure;
        semilogy(freq_E, magnitude_E, 'b-', sr_freq_E, sr_magnitude_E, 'r--');
        xlabel('Frequency (Hz)');
        ylabel('Magnitude');
        title(sprintf('Frequency Spectrum of %s Tuning Fork (%s Hz)', note_E, freq_label_E));
        legend('FFT Spectrum', 'SR760 Spectrum');
        grid on;
        xlim([0, 1500]);  % Limit x-axis to 1500 Hz
    else
        figure;
        semilogy(freq_E, magnitude_E, 'b-');
        xlabel('Frequency (Hz)');
        ylabel('Magnitude');
        title(sprintf('FFT Spectrum of %s Tuning Fork (%s Hz)', note_E, freq_label_E));
        grid on;
        xlim([0, 1500]);
    end
end

%% Part F: Voice Analysis
% Analyzes human voice signals using FFT and compares them with SR760 data.

% Folders containing data
oscill_folder_F = fullfile(root_path, 'voice_data_oscill');
spect_folder_F = fullfile(root_path, 'voice_data_spect');

% List of voice samples
voice_samples_F = {
    'voice_low', 'voice_low-spect', 'Low Tone';
    'voice_med', 'voice_medium-spect', 'Medium Tone';
    'voice_high', 'voice_high-spect', 'High Tone';
};

% Loop over each voice sample
for i = 1:size(voice_samples_F, 1)
    oscill_label_F = voice_samples_F{i, 1};
    spect_file_name_F = voice_samples_F{i, 2};
    description_F = voice_samples_F{i, 3};

    % Time-Domain Data Analysis
    data_folder_F = fullfile(oscill_folder_F, oscill_label_F);
    csv_files_F = dir(fullfile(data_folder_F, '*.CSV'));
    if isempty(csv_files_F)
        csv_files_F = dir(fullfile(data_folder_F, '*.csv'));
    end
    if isempty(csv_files_F)
        warning('No CSV files found in folder: %s', data_folder_F);
        continue;
    end
    csv_file_F = fullfile(data_folder_F, csv_files_F(1).name);
    data_F = readmatrix(csv_file_F, 'NumHeaderLines', 18);
    time_F = data_F(:, 4);        % Time in seconds
    voltage_F = data_F(:, 5);     % Voltage in volts

    % Plot the time-domain waveform
    figure;
    plot(time_F * 1000, voltage_F, 'b-');
    xlabel('Time (ms)');
    ylabel('Voltage (V)');
    title(sprintf('Time-Domain Waveform of %s', description_F));
    grid on;

    % Frequency-Domain Analysis using FFT
    Ts_F = time_F(2) - time_F(1);
    Fs_F = 1 / Ts_F;
    N_F = length(voltage_F);
    fft_voltage_F = fft(voltage_F)/N_F;
    freq_F = (0:N_F-1)*(Fs_F/N_F);
    nyq_F = floor(N_F/2);
    freq_F = freq_F(1:nyq_F);
    magnitude_F = 2 * abs(fft_voltage_F(1:nyq_F));

    % Read SR760 Spectrum Analyzer Data
    spect_file_F = fullfile(spect_folder_F, spect_file_name_F);
    if isfile(spect_file_F)
        sr760_data_F = readmatrix(spect_file_F, 'FileType', 'text');
        sr_freq_F = sr760_data_F(:, 1);
        sr_magnitude_F = sr760_data_F(:, 2);

        % Plot comparison of FFT and SR760 spectra
        figure;
        semilogy(freq_F, magnitude_F, 'b-', sr_freq_F, sr_magnitude_F, 'r--');
        xlabel('Frequency (Hz)');
        ylabel('Magnitude');
        title(sprintf('Frequency Spectrum of %s', description_F));
        legend('FFT Spectrum', 'SR760 Spectrum');
        grid on;
        xlim([0, 1500]);  % Limit x-axis to 1500 Hz
    else
        figure;
        semilogy(freq_F, magnitude_F, 'b-');
        xlabel('Frequency (Hz)');
        ylabel('Magnitude');
        title(sprintf('FFT Spectrum of %s', description_F));
        grid on;
        xlim([0, 1500]);
    end
end
