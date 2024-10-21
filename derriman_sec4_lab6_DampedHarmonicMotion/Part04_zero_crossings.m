% -----------------------------------------------------------------
% Find Zero Crossings for Position, Velocity, Acceleration
% -----------------------------------------------------------------

% Find Zero Crossings for Position, Velocity, Acceleration
[pos_crossTimes, pos_crossIndex] = zeroCross(displArr2, t);
[vel_crossTimes, vel_crossIndex] = zeroCross(velArr, t);
[accel_crossTimes, accel_crossIndex] = zeroCross(accelArr, t);

% Plot Oscillations with zero-crossings
figure;

subplot(3,1,1); plot(t, displArr2, 'b');  hold on;
plot(pos_crossTimes, displArr2(pos_crossIndex), 'rx');
title('Position vs Time*');
xlabel('Time (s)');  ylabel('Position (m)');
hold off;

subplot(3,1,2); plot(t, velArr, 'b');  hold on;
plot(vel_crossTimes, velArr(vel_crossIndex), 'rx');
title('Velocity vs Time');
xlabel('Time (s)');  ylabel('Velocity (m/s)');
hold off;

subplot(3,1,3); plot(t, accelArr, 'b');  hold on;
plot(accel_crossTimes, accelArr(accel_crossIndex), 'rx');
title('Acceleration vs Time');
xlabel('Time (s)');  ylabel('Acceleration (m/s^2)');
hold off;

% Add annotation to indicate the asterisk explanation
annotation('textbox', [0.1, 0.01, 0.8, 0.05], 'String', ...
    '*Values shifted by mean to oscillate about zero.', 'EdgeColor', 'none', ...
    'HorizontalAlignment', 'center', 'FontSize', 10);
