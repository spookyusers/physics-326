% Combined MATLAB Code for Lab Parts A–F with Adjusted Figures and Captions

% Initialize the environment
clc; clear; close all;

% Set the root path relative to the current working directory
root_path = './data';
figure_folder = './figures';  % Folder to save figures

% Create the figures directory if it doesn't exist
if ~exist(figure_folder, 'dir')
    mkdir(figure_folder);
end

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
figure('Position', [100, 100, 800, 700]); % Increase figure height
plot(t_A, y_sums_A(1,:), 'b-', 'LineWidth', 1.5); hold on;
plot(t_A, y_sums_A(2,:), 'r--', 'LineWidth', 1.5);
plot(t_A, y_sums_A(3,:), 'g-.', 'LineWidth', 1.5);
plot(t_A, y_sums_A(4,:), 'k:', 'LineWidth', 1.5);
plot(t_A, y_sums_A(5,:), 'm-', 'LineWidth', 1.5);
grid on;
legend('N=1', 'N=3', 'N=5', 'N=7', 'N=9', 'Location', 'northwest');
ylabel('Amplitude');

% Remove x-axis label
% xlabel('Time (s)');

% Adjust axes position to make room for caption
ax = gca;
ax.Position = [0.13, 0.25, 0.775, 0.65];

% Add caption as text box below the plot
caption = {'Figure 1: Square Wave Synthesis with Increasing Number of Harmonics', ...
    'This figure illustrates the approximation of a square wave by summing odd harmonics up to N=9 using Fourier series.', ...
    'Time is in seconds along the horizontal axis.'};
annotation('textbox', [0.13, 0.1, 0.775, 0.12], 'String', caption, 'EdgeColor', 'none', ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontSize', 10);

% Disable axes toolbar
ax.Toolbar.Visible = 'off';

% Save the figure
exportgraphics(gcf, fullfile(figure_folder, 'Figure1_SquareWaveSynthesis.png'));

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
figure('Position', [100, 100, 800, 700]); % Increase figure height
plot(t_B, f_exact_B, 'k-', 'LineWidth', 1.5, 'DisplayName', 'Exact Sawtooth');
hold on;
plot(t_B, f_fourier_B, 'r--', 'LineWidth', 1.5, 'DisplayName', 'Fourier Approximation (n=5)');
grid on;
ylabel('Amplitude');
legend('Location', 'northwest');

% Remove x-axis label
% xlabel('Time (s)');

% Adjust axes position to make room for caption
ax = gca;
ax.Position = [0.13, 0.25, 0.775, 0.65];

% Add caption as text box below the plot
caption = {'Figure 2: Sawtooth Wave - Exact vs Fourier Series Approximation', ...
    'This figure compares the exact sawtooth wave with its Fourier series approximation using up to n=5 harmonics.', ...
    'Time is in seconds along the horizontal axis.'};
annotation('textbox', [0.13, 0.1, 0.775, 0.12], 'String', caption, 'EdgeColor', 'none', ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontSize', 10);

% Disable axes toolbar
ax.Toolbar.Visible = 'off';

% Save the figure
exportgraphics(gcf, fullfile(figure_folder, 'Figure2_SawtoothWaveSynthesis.png'));

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

% Plot time-domain square wave and frequency spectrum
figure('Position', [100, 100, 800, 700]); % Increase figure height
subplot(2,1,1);
plot(t_D*1000, square_wave_D, 'b-');
ylabel('Amplitude');
grid on;

% Remove x-axis label
% xlabel('Time (ms)');

subplot(2,1,2);
stem(freq_D(indices_D)/1000, fft_magnitudes_square_D, 'b', 'LineWidth', 1.5); hold on;
stem(freq_D(indices_D)/1000, An_D, 'r--', 'LineWidth', 1.5);
ylabel('Magnitude');
legend('FFT Magnitudes', 'Theoretical Coefficients');
grid on;

% Remove x-axis label
% xlabel('Frequency (kHz)');

% Adjust subplot positions to make room for caption
subplot(2,1,1);
ax1 = gca;
ax1.Position = [0.13, 0.55, 0.775, 0.35];
subplot(2,1,2);
ax2 = gca;
ax2.Position = [0.13, 0.3, 0.775, 0.2];

% Add caption as text box below the plots
caption = {'Figure 3: Square Wave - Time Domain and Frequency Spectrum', ...
    'The upper plot shows the time-domain square wave (Time in ms), and the lower plot compares FFT magnitudes with theoretical Fourier coefficients (Frequency in kHz).'};
annotation('textbox', [0.13, 0.1, 0.775, 0.15], 'String', caption, 'EdgeColor', 'none', ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontSize', 10);

% Disable axes toolbars
ax1.Toolbar.Visible = 'off';
ax2.Toolbar.Visible = 'off';

% Save the figure
exportgraphics(gcf, fullfile(figure_folder, 'Figure3_SquareWaveAnalysis.png'));

% Triangular Wave Analysis
triangular_wave_D = sawtooth(2*pi*1000*t_D, 0.5);  % Symmetric triangle wave
fft_triangle_D = fft(triangular_wave_D)/N_D;
mag_triangle_D = 2*abs(fft_triangle_D(1:nyq_D));
Bn_D = (8./(pi^2)) .* ((-1).^((n_values_D-1)/2)) ./ (n_values_D.^2);
fft_magnitudes_triangle_D = mag_triangle_D(indices_D);

% Plot time-domain triangular wave and frequency spectrum
figure('Position', [100, 100, 800, 700]); % Increase figure height
subplot(2,1,1);
plot(t_D*1000, triangular_wave_D, 'b-');
ylabel('Amplitude');
grid on;

% Remove x-axis label
% xlabel('Time (ms)');

subplot(2,1,2);
stem(freq_D(indices_D)/1000, fft_magnitudes_triangle_D, 'b', 'LineWidth', 1.5); hold on;
stem(freq_D(indices_D)/1000, abs(Bn_D), 'r--', 'LineWidth', 1.5);
ylabel('Magnitude');
legend('FFT Magnitudes', 'Theoretical Coefficients');
grid on;

% Remove x-axis label
% xlabel('Frequency (kHz)');

% Adjust subplot positions to make room for caption
subplot(2,1,1);
ax1 = gca;
ax1.Position = [0.13, 0.55, 0.775, 0.35];
subplot(2,1,2);
ax2 = gca;
ax2.Position = [0.13, 0.3, 0.775, 0.2];

% Add caption as text box below the plots
caption = {'Figure 4: Triangular Wave - Time Domain and Frequency Spectrum', ...
    'The upper plot shows the time-domain triangular wave (Time in ms), and the lower plot compares FFT magnitudes with theoretical Fourier coefficients (Frequency in kHz).'};
annotation('textbox', [0.13, 0.1, 0.775, 0.15], 'String', caption, 'EdgeColor', 'none', ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontSize', 10);

% Disable axes toolbars
ax1.Toolbar.Visible = 'off';
ax2.Toolbar.Visible = 'off';

% Save the figure
exportgraphics(gcf, fullfile(figure_folder, 'Figure4_TriangularWaveAnalysis.png'));

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
    figure_number = 5 + (i-1)*2;  % To assign figure numbers correctly

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
    figure('Position', [100, 100, 800, 700]); % Increase figure height
    plot(time_E * 1000, voltage_E, 'b-');
    ylabel('Voltage (V)');
    grid on;

    % Remove x-axis label
    % xlabel('Time (ms)');

    % Adjust axes position to make room for caption
    ax = gca;
    ax.Position = [0.13, 0.3, 0.775, 0.6];

    % Add caption as text box below the plot
    caption = {sprintf('Figure %d: Time-Domain Waveform of %s Tuning Fork', figure_number, note_E), ...
        sprintf('This figure displays the time-domain waveform of the %s tuning fork (%s Hz). Time is in milliseconds along the horizontal axis.', note_E, freq_label_E)};
    annotation('textbox', [0.13, 0.11, 0.775, 0.15], 'String', caption, 'EdgeColor', 'none', ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontSize', 10);

    % Disable axes toolbar
    ax.Toolbar.Visible = 'off';

    % Save the figure
    exportgraphics(gcf, fullfile(figure_folder, sprintf('Figure%d_TuningFork_%s_TimeDomain.png', figure_number, note_E)));

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
        figure('Position', [100, 100, 800, 700]); % Increase figure height
        semilogy(freq_E, magnitude_E, 'b-', sr_freq_E, sr_magnitude_E, 'r--');
        ylabel('Magnitude');
        legend('FFT Spectrum', 'SR760 Spectrum');
        grid on;
        xlim([0, 1500]);  % Limit x-axis to 1500 Hz
    else
        figure('Position', [100, 100, 800, 700]); % Increase figure height
        semilogy(freq_E, magnitude_E, 'b-');
        ylabel('Magnitude');
        grid on;
        xlim([0, 1500]);
    end

    % Remove x-axis label
    % xlabel('Frequency (Hz)');

    % Adjust axes position to make room for caption
    ax = gca;
    ax.Position = [0.13, 0.3, 0.775, 0.6];

    % Add caption as text box below the plot
    caption = {sprintf('Figure %d: Frequency Spectrum of %s Tuning Fork', figure_number+1, note_E), ...
        sprintf('This figure presents the frequency spectrum of the %s tuning fork (%s Hz), comparing FFT and SR760 data.', note_E, freq_label_E), ...
        'Frequency is in Hz along the horizontal axis.'};
    annotation('textbox', [0.13, 0.11, 0.775, 0.15], 'String', caption, 'EdgeColor', 'none', ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontSize', 10);

    % Disable axes toolbar
    ax.Toolbar.Visible = 'off';

    % Save the figure
    exportgraphics(gcf, fullfile(figure_folder, sprintf('Figure%d_TuningFork_%s_FrequencySpectrum.png', figure_number+1, note_E)));
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
    figure_number = 11 + (i-1)*2;  % To assign figure numbers correctly

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
    figure('Position', [100, 100, 800, 700]); % Increase figure height
    plot(time_F * 1000, voltage_F, 'b-');
    ylabel('Voltage (V)');
    grid on;

    % Remove x-axis label
    % xlabel('Time (ms)');

    % Adjust axes position to make room for caption
    ax = gca;
    ax.Position = [0.13, 0.3, 0.775, 0.6];

    % Add caption as text box below the plot
    caption = {sprintf('Figure %d: Time-Domain Waveform of %s', figure_number, description_F), ...
        sprintf('This figure displays the time-domain waveform of the %s voice sample. Time is in milliseconds along the horizontal axis.', description_F)};
    annotation('textbox', [0.13, 0.11, 0.775, 0.15], 'String', caption, 'EdgeColor', 'none', ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontSize', 10);

    % Disable axes toolbar
    ax.Toolbar.Visible = 'off';

    % Save the figure
    exportgraphics(gcf, fullfile(figure_folder, sprintf('Figure%d_Voice_%s_TimeDomain.png', figure_number, description_F)));

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
        figure('Position', [100, 100, 800, 700]); % Increase figure height
        semilogy(freq_F, magnitude_F, 'b-', sr_freq_F, sr_magnitude_F, 'r--');
        ylabel('Magnitude');
        legend('FFT Spectrum', 'SR760 Spectrum');
        grid on;
        xlim([0, 1500]);  % Limit x-axis to 1500 Hz
    else
        figure('Position', [100, 100, 800, 700]); % Increase figure height
        semilogy(freq_F, magnitude_F, 'b-');
        ylabel('Magnitude');
        grid on;
        xlim([0, 1500]);
    end

    % Remove x-axis label
    % xlabel('Frequency (Hz)');

    % Adjust axes position to make room for caption
    ax = gca;
    ax.Position = [0.13, 0.3, 0.775, 0.6];

    % Add caption as text box below the plot
    caption = {sprintf('Figure %d: Frequency Spectrum of %s', figure_number+1, description_F), ...
        sprintf('This figure presents the frequency spectrum of the %s voice sample, comparing FFT and SR760 data. Frequency is in Hz along the horizontal axis.', description_F)};
    annotation('textbox', [0.13, 0.11, 0.775, 0.15], 'String', caption, 'EdgeColor', 'none', ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontSize', 10);

    % Disable axes toolbar
    ax.Toolbar.Visible = 'off';

    % Save the figure
    exportgraphics(gcf, fullfile(figure_folder, sprintf('Figure%d_Voice_%s_FrequencySpectrum.png', figure_number+1, description_F)));
end
