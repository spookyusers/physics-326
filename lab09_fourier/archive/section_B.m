% Section B: Sawtooth Wave Synthesis
clear; close all; clc;

% Parameters
T = 1;          % Period (seconds)
t = -T/2:0.001:T/2;  % Time vector
N = 1:5;        % Harmonics up to n=5

% Exact sawtooth
f_exact = 2*t;

% Preallocate for Fourier sum
f_fourier = zeros(1,length(t));

% Calculation loop
for n = N
    % Sawtooth wave Fourier series
    an = -(2/pi)*((-1)^n/n);  % Coefficient formula from your derivation
    f_fourier = f_fourier + an*sin(2*pi*n*t/T);
end

% Plot
figure
plot(t, f_exact, 'k-', 'LineWidth', 1.5, 'DisplayName', 'Exact')
hold on
plot(t, f_fourier, 'r--', 'LineWidth', 1.5, 'DisplayName', 'Fourier n=5')
grid on
xlabel('Time (s)')
ylabel('Amplitude')
title('Sawtooth Wave: Exact vs Fourier Series')
legend('Location', 'best')