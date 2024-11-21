% Section D: Waveform Analysis

% Parameters for reading CSV
filename = 'D1D2/ALL0034/F0034CH1.CSV';
skipLines = 18;  % Skip header info

% Read data
data = readmatrix(filename, 'NumHeaderLines', skipLines);

% Extract time and voltage
time = data(:,1);
voltage = data(:,2);

% Calculate FFT
Fs = 1/(time(2)-time(1));  % Sampling frequency
N = length(voltage);        % Number of points
fft_data = fft(voltage)/N;  % Normalize by N
freq = (0:N-1)*(Fs/N);     % Frequency vector

% Only plot up to Nyquist frequency
nyq_idx = ceil(N/2);
magnitude = 2*abs(fft_data(1:nyq_idx));  % Multiply by 2 for single-sided spectrum
freq = freq(1:nyq_idx);

% Plotting
figure;
subplot(2,1,1)
plot(time*1000, voltage)  % Time in ms
xlabel('Time (ms)')
ylabel('Voltage (V)')
title('Time Domain')
grid on

subplot(2,1,2)
plot(freq/1000, magnitude)  % Freq in kHz
xlabel('Frequency (kHz)')
ylabel('Magnitude')
title('Frequency Domain')
grid on