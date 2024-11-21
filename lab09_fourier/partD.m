% Part D: Square Wave Analysis
clear; clc; close all;

% Parameters
T = 1/1000;                % Period for 1 kHz
Fs = 100000;               % Sampling frequency (100 kHz)
t = 0:1/Fs:2*T;            % Time vector covering two periods

% Generate square wave
square_wave = square(2*pi*1000*t);

% Compute FFT
N = length(square_wave);
fft_square = fft(square_wave)/N;
freq = (0:N-1)*(Fs/N);

% Positive frequencies
nyq = floor(N/2);
freq = freq(1:nyq);
mag_square = 2*abs(fft_square(1:nyq));

% Theoretical Fourier coefficients (odd harmonics)
n_harmonics = 20;
n_values = 1:2:(2*n_harmonics-1);  % Odd harmonics
An = 4./(n_values*pi);

% Harmonic frequencies
harmonic_freqs = 1000 * n_values;  % in Hz

% Indices of harmonic frequencies
[~, indices] = arrayfun(@(f) min(abs(freq - f)), harmonic_freqs);

% Extract FFT magnitudes
fft_magnitudes = mag_square(indices);

% Plotting
figure;
subplot(2,1,1);
plot(t*1000, square_wave, 'b-');
xlabel('Time (ms)');
ylabel('Amplitude');
title('Square Wave - Time Domain');
grid on;

subplot(2,1,2);
stem(freq(indices)/1000, fft_magnitudes, 'b', 'LineWidth', 1.5); hold on;
stem(freq(indices)/1000, An, 'r--', 'LineWidth', 1.5);
xlabel('Frequency (kHz)');
ylabel('Magnitude');
title('FFT Magnitudes vs Theoretical Fourier Coefficients');
legend('FFT Magnitudes', 'Theoretical Coefficients');
grid on;

%% Triangular Wave Analysis

% Generate triangular wave
triangular_wave = sawtooth(2*pi*1000*t, 0.5);  % Symmetric triangle wave

% Compute FFT
fft_triangle = fft(triangular_wave)/N;
mag_triangle = 2*abs(fft_triangle(1:nyq));

% Theoretical Fourier coefficients (odd harmonics)
Bn = (8./(pi^2)) .* ((-1).^((n_values-1)/2)) ./ (n_values.^2);

% Extract FFT magnitudes
fft_magnitudes = mag_triangle(indices);

% Plotting
figure;
subplot(2,1,1);
plot(t*1000, triangular_wave, 'b-');
xlabel('Time (ms)');
ylabel('Amplitude');
title('Triangular Wave - Time Domain');
grid on;

subplot(2,1,2);
stem(freq(indices)/1000, fft_magnitudes, 'b', 'LineWidth', 1.5); hold on;
stem(freq(indices)/1000, abs(Bn), 'r--', 'LineWidth', 1.5);
xlabel('Frequency (kHz)');
ylabel('Magnitude');
title('FFT Magnitudes vs Theoretical Fourier Coefficients');
legend('FFT Magnitudes', 'Theoretical Coefficients');
grid on;
