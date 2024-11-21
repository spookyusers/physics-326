%% Section D: Overall Setup
clear all;
close all;

%% D.I Part 1: Square Wave Theoretical Analysis and SR760 Comparison
% Load spectrum data
spectrum_linear = readmatrix('spectrum/D1LogScaleARangeOn', 'FileType', 'text');
freq_spectrum = spectrum_linear(:,1);
mag_spectrum_db = spectrum_linear(:,2);
mag_spectrum = 10.^(mag_spectrum_db/20);  % Convert from dB to linear

% Theoretical calculations
T = 1/1000;  % Period for 1kHz
t = linspace(-T/2, T/2, 1000);
Fs = 1/mean(diff(t));  % Sampling frequency

% Perfect square wave (odd harmonics only)
perfect_square = zeros(size(t));
n_terms = 20;
odd_harmonics = 1:2:n_terms;

for n = odd_harmonics
   perfect_square = perfect_square + (4/(n*pi))*sin(2*pi*n*t/T);
end

% Scale perfect square to match measurement amplitude
perfect_square = perfect_square * 0.25;  % Scale to match ±0.25V amplitude

% Imperfect square wave
dc_offset = 0.01;
imperfect_square = perfect_square + dc_offset;
even_harmonic_magnitude = perfect_square(1)/31.6;  % -30dB relative to fundamental
even_harmonics = 2:2:20;

for n = even_harmonics
   imperfect_square = imperfect_square + even_harmonic_magnitude*sin(2*pi*n*t/T);
end

% Calculate FFT
N = length(t);
freq = linspace(0, Fs/2, N/2+1);  % Positive frequencies only

% Calculate FFTs
fft_perfect = fft(perfect_square);
fft_imperfect = fft(imperfect_square);

% Get magnitudes (single-sided)
mag_perfect = abs(fft_perfect(1:N/2+1))/N;
mag_perfect(2:end-1) = 2*mag_perfect(2:end-1);
mag_imperfect = abs(fft_imperfect(1:N/2+1))/N;
mag_imperfect(2:end-1) = 2*mag_imperfect(2:end-1);

% Create theoretical comparison plots
figure('Position', [100, 100, 800, 900]);
sgtitle('Square Wave Analysis - Theory vs SR760');

subplot(3,1,1)
plot(t*1000, perfect_square, 'b-', t*1000, imperfect_square, 'r--', 'LineWidth', 1)
xlabel('Time (ms)')
ylabel('Amplitude')
title('Time Domain')
legend('Perfect', 'Imperfect')
grid on

subplot(3,1,2)
plot(freq/1000, mag_perfect, 'b-', freq/1000, mag_imperfect, 'r--', ...
   freq_spectrum/1000, mag_spectrum, 'g-.', 'LineWidth', 1)
xlabel('Frequency (kHz)')
ylabel('Magnitude')
title('Frequency Domain - Linear Scale')
legend('Perfect', 'Imperfect', 'SR760')
grid on
xlim([0 50])

subplot(3,1,3)
semilogy(freq/1000, mag_perfect, 'b-', freq/1000, mag_imperfect, 'r--', ...
   freq_spectrum/1000, mag_spectrum, 'g-.', 'LineWidth', 1)
xlabel('Frequency (kHz)')
ylabel('Magnitude (log scale)')
title('Frequency Domain - Log Scale')
legend('Perfect', 'Imperfect', 'SR760')
grid on
xlim([0 50])
ylim([1e-4 1])

%% D.I Part 2: Measured Square Wave Analysis
folders = {'ALL0034', 'ALL0035', 'ALL0036', 'ALL0037', 'ALL0038', 'ALL0039'};
base_path = 'D1D2/';

for i = 1:length(folders)
   filename = fullfile(base_path, folders{i}, ['F', folders{i}(4:end), 'CH1.CSV']);
   data = readmatrix(filename, 'NumHeaderLines', 18);
   
   time = data(:,4);
   voltage = data(:,5);
   Ts = time(2)-time(1);
   Fs = 1/Ts;
   
   % Calculate FFT
   N = length(voltage);
   fft_data = fft(voltage);
   freq_meas = (0:(N/2))*Fs/N;
   
   % Single-sided magnitude spectrum
   magnitude = abs(fft_data(1:N/2+1))/N;
   magnitude(2:end-1) = 2*magnitude(2:end-1);
   
   % Create individual measurement plots
   figure('Position', [100, 100, 800, 900]);
   
   subplot(3,1,1)
   plot(time*1000, voltage, 'b-', 'LineWidth', 1)
   xlabel('Time (ms)')
   ylabel('Voltage (V)')
   title(sprintf('Time Domain - %s', folders{i}))
   grid on
   
   subplot(3,1,2)
   plot(freq_meas/1000, magnitude, 'r-', freq_spectrum/1000, mag_spectrum, 'g-.', 'LineWidth', 1)
   xlabel('Frequency (kHz)')
   ylabel('Magnitude')
   title('Frequency Domain - Linear Scale')
   legend('Measured', 'SR760')
   grid on
   xlim([0 50])
   
   subplot(3,1,3)
   semilogy(freq_meas/1000, magnitude, 'r-', freq_spectrum/1000, mag_spectrum, 'g-.', 'LineWidth', 1)
   xlabel('Frequency (kHz)')
   ylabel('Magnitude (log scale)')
   title('Frequency Domain - Log Scale')
   legend('Measured', 'SR760')
   grid on
   xlim([0 50])
   ylim([1e-4 1])
   
   % Analysis
   [peaks, locs] = findpeaks(magnitude, 'MinPeakHeight', max(magnitude)*0.01);
   fundamental_freq = freq_meas(locs(1))/1000;
   
   fprintf('\nAnalysis for %s:\n', folders{i});
   fprintf('Fundamental: %.1f kHz\n', fundamental_freq);
   
   % Compare measured ratios to theoretical
   fprintf('Harmonic ratios (measured vs theoretical):\n');
   for j = 2:min(5,length(peaks))
       measured_ratio = peaks(j)/peaks(1);
       theoretical_ratio = 1/((2*j-1));
       fprintf('Harmonic %d: %.4f vs %.4f\n', j, measured_ratio, theoretical_ratio);
   end
   
   % Calculate dB difference for largest even harmonic
   sorted_peaks = sort(peaks, 'descend');
   db_diff = 20*log10(sorted_peaks(1)/sorted_peaks(2));
   fprintf('Second largest peak: %.1f dB below fundamental\n', db_diff);
end

%% D.II: Triangular Wave Analysis
% [ add this section once D.I is working correctly]