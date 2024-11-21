%% Section D: Theoretical Square Wave Analysis
clear; close all; clc;

T = 1/1000;  % Period for 1kHz
t = linspace(-T/2, T/2, 1000);

% Perfect square wave (odd harmonics only)
perfect_square = zeros(size(t));
n_terms = 20;
odd_harmonics = 1:2:n_terms;

for n = odd_harmonics
   perfect_square = perfect_square + (4/(n*pi))*sin(2*pi*n*t/T);
end

% Imperfect square wave with even harmonics
dc_offset = 0.01;
imperfect_square = perfect_square + dc_offset;
even_harmonic_magnitude = 0.04;  % ~30dB down
even_harmonics = 2:2:20;

for n = even_harmonics
   imperfect_square = imperfect_square + even_harmonic_magnitude*sin(2*pi*n*t/T);
end

% Calculate FFT for both signals
Fs = length(t)/T;
freq = (0:length(t)/2-1)*(Fs/length(t));

fft_perfect = fft(perfect_square)/length(t);
mag_perfect = 2*abs(fft_perfect(1:length(t)/2));

fft_imperfect = fft(imperfect_square)/length(t);
mag_imperfect = 2*abs(fft_imperfect(1:length(t)/2));

% Plot theoretical comparison
figure('Position', [100, 100, 800, 900]);

subplot(3,1,1)
plot(t*1000, perfect_square, 'b-', t*1000, imperfect_square, 'r--', 'LineWidth', 1)
xlabel('Time (ms)')
ylabel('Amplitude')
title('Theoretical Time Domain Comparison')
legend('Perfect', 'Imperfect')
grid on

subplot(3,1,2)
plot(freq/1000, mag_perfect, 'b-', freq/1000, mag_imperfect, 'r--', 'LineWidth', 1)
xlabel('Frequency (kHz)')
ylabel('Magnitude')
title('Frequency Domain - Linear Scale')
legend('Perfect', 'Imperfect')
grid on
xlim([0 50])

subplot(3,1,3)
semilogy(freq/1000, mag_perfect, 'b-', freq/1000, mag_imperfect, 'r--', 'LineWidth', 1)
xlabel('Frequency (kHz)')
ylabel('Magnitude (log scale)')
title('Frequency Domain - Log Scale')
legend('Perfect', 'Imperfect')
grid on
xlim([0 50])
ylim([1e-4 1])

%% Section D: Experimental Data Analysis
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
   fft_data = fft(voltage)/N;
   freq = (0:N-1)*(Fs/N);
   
   nyq_idx = ceil(N/2);
   magnitude = 2*abs(fft_data(1:nyq_idx));
   freq = freq(1:nyq_idx);
   
   % Create plots
   figure('Position', [100, 100, 800, 900]);
   
   subplot(3,1,1)
   plot(time*1000, voltage, 'b-', 'LineWidth', 1)
   xlabel('Time (ms)')
   ylabel('Voltage (V)')
   title(sprintf('Time Domain - %s', folders{i}))
   grid on
   
   subplot(3,1,2)
   plot(freq/1000, magnitude, 'r-', 'LineWidth', 1)
   xlabel('Frequency (kHz)')
   ylabel('Magnitude')
   title('Frequency Domain - Linear Scale')
   grid on
   xlim([0 50])
   
   subplot(3,1,3)
   semilogy(freq/1000, magnitude, 'r-', 'LineWidth', 1)
   xlabel('Frequency (kHz)')
   ylabel('Magnitude (log scale)')
   title('Frequency Domain - Log Scale')
   grid on
   xlim([0 50])
   ylim([1e-4 1])
   
   % Find peaks and calculate ratios
   [peaks, locs] = findpeaks(magnitude, 'MinPeakHeight', max(magnitude)*0.01);
   fundamental_freq = freq(locs(1))/1000;
   
   fprintf('\nAnalysis for %s:\n', folders{i});
   fprintf('Fundamental: %.1f kHz\n', fundamental_freq);
   
   % Compare measured ratios to theoretical
   fprintf('Harmonic ratios (measured vs theoretical):\n');
   for j = 2:min(5,length(peaks))  % First 5 harmonics only
       measured_ratio = peaks(j)/peaks(1);
       theoretical_ratio = 1/((2*j-1));  % For square wave
       fprintf('Harmonic %d: %.4f vs %.4f\n', j, measured_ratio, theoretical_ratio);
   end
   
   % Calculate dB difference for largest even harmonic
   sorted_peaks = sort(peaks, 'descend');
   db_diff = 20*log10(sorted_peaks(1)/sorted_peaks(2));
   fprintf('Second largest peak: %.1f dB below fundamental\n', db_diff);
end