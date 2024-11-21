% Section A: Square Wave Synthesis
clear; close all; clc;
% Parameters
T = 1;          % Period (seconds)
t = -T/2:0.001:T/2;  % Time vector, small steps for smooth plot
N = [1 3 5 7 9];     % Harmonic components
%%
% Preallocate arrays for different harmonic sums
y1 = zeros(1,length(t));    % 1+3
y2 = zeros(1,length(t));    % 1+3+5
y3 = zeros(1,length(t));    % 1+3+5+7
y4 = zeros(1,length(t));    % 1+3+5+7+9
%%
% Calculation loop
for i = 1:length(N)
    n = N(i);
    An = 4/(n*pi);  % Fourier coefficient for square wave
    harm = An*cos(2*pi*n*t/T);
    
    y1 = y1 + (i<=2)*harm;  % First 2 terms
    y2 = y2 + (i<=3)*harm;  % First 3 terms
    y3 = y3 + (i<=4)*harm;  % First 4 terms
    y4 = y4 + harm;         % All terms
end
%%
% Plot
figure
plot(t, y1, 'b-', t, y2, 'r--', t, y3, 'g-.', t, y4, 'k:', 'LineWidth', 1.5)
grid on
legend('1+3', '1+3+5', '1+3+5+7', '1+3+5+7+9')
xlabel('Time (s)')
ylabel('Amplitude')
title('Square Wave Synthesis')
%%
% Alternate
% Part A: Square Wave Synthesis
T = 1;                          % Period (seconds)
t = -T/2:0.001:T/2;             % Time vector
N_values = [1, 3, 5, 7, 9];     % Harmonic components

% Initialize array to store partial sums
y_sums = zeros(length(N_values), length(t));

for idx = 1:length(N_values)
    N = N_values(idx);
    y = zeros(size(t));
    for n = 1:2:N               % Sum over odd harmonics
        Bn = 4/(n*pi);
        y = y + Bn * sin(2*pi*n*t/T);
    end
    y_sums(idx, :) = y;
end

% Plotting the harmonic sums
figure;
plot(t, y_sums(1,:), 'b-', 'LineWidth', 1.5); hold on;
plot(t, y_sums(2,:), 'r--', 'LineWidth', 1.5);
plot(t, y_sums(3,:), 'g-.', 'LineWidth', 1.5);
plot(t, y_sums(4,:), 'k:', 'LineWidth', 1.5);
plot(t, y_sums(5,:), 'm-', 'LineWidth', 1.5);
grid on;
legend('N=1', 'N=3', 'N=5', 'N=7', 'N=9');
xlabel('Time (s)');
ylabel('Amplitude');
title('Square Wave Synthesis with Increasing Number of Harmonics');
