% --------------------------------------------------
% Plot Velocity as a Function of Position
% --------------------------------------------------
figure;
plot(positions, velocities, 'b');
grid on;
box on;
title('Velocity vs Position', 'FontSize', 14);
xlabel('Position (m)', 'FontSize', 11);
ylabel('Velocity (m/s)', 'FontSize', 11);
set(gca, 'FontSize', 12);
legend('Velocity vs Position');
