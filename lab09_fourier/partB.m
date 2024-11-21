% Part B: Sawtooth Wave Synthesis
clear; close all; clc;

T = 1;                          % Period (seconds)
t = -T/2:0.001:T/2;             % Time vector
N = 1:5;                        % Harmonics up to n=5

% Exact sawtooth wave
f_exact = 2*(t/T);

% Fourier series approximation
f_fourier = zeros(size(t));
for n = N
    Bn = (-2*(-1)^n)/(n*pi);
    f_fourier = f_fourier + Bn * sin(2*pi*n*t/T);
end

% Plotting
figure;
plot(t, f_exact, 'k-', 'LineWidth', 1.5, 'DisplayName', 'Exact Sawtooth');
hold on;
plot(t, f_fourier, 'r--', 'LineWidth', 1.5, 'DisplayName', 'Fourier Approximation (n=5)');
grid on;
xlabel('Time (s)');
ylabel('Amplitude');
title('Sawtooth Wave: Exact vs Fourier Series Approximation');
legend('Location', 'best');
