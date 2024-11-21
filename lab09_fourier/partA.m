% Part A: Square Wave Synthesis
clc; clear; close all;

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
%title('Square Wave Synthesis with Increasing Number of Harmonics');
