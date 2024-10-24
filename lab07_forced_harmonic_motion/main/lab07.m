% PreLab Work Lab 07 Forced Harmonic Motion
% Kym Derriman

%% Case 1: Without damping disk

M_D = .3274; % mass disk kg
M_A = .200; % mass it takes to have omega between 5-6

tbl = readtable('Lab7_EvA1.txt');
thetaArr = tbl.Angle2; % rotary arm angle data
tArr = tbl.Time; % time array (same for both x and theta)
omega = tbl.Velocity2; % Drive frequency (rad/s)

theta_means = mean(thetaArr);
theta_std = std(thetaArr);
theta_stdMean= theta_std / sqrt(length(thetaArr));


a = thetaArr >= 0;
b = thetaArr< 0;
c = a(1:end-1) & b(2:end);

zX = tArr(c); % zero crossing times from theta data

% period and uncertainty
w = 1 ./ (theta_stdMean.^ 2);
[T, sigmaT,~,~] = periodPhase(zX, w, 'Theta');

% Calculate natural frequency
w0 = 2*pi / T;
fprintf('Natural Frequency: %.4f\n', w0);


%% Tracking variables and equations from manual



xt = x0 * cos(omega0 * t);

F0 = -R * Df(xt, t); % Damping force F = -R dx/dt
Ft = F0 * sin(omega*t); % Periodic force on the weight
gamma = R / (2*m); % Damping constant

% Amplitude = (F0/m)/(sqrt(w0^2 - w^2) + (4gamma^2omega^2))
A = (...
    (F_0 / m) /...
    sqrt((omega0^2 - omega^2) + (4 * gamma^2 * omega^2)) ...
    );
phi = atan((2*gamma*omega) / (omega^2 - omega0^2)); % Phase shift

vt = Df(xt, t);


t0 = (pi/2)/omega; % Time when Damping Force maximum
t1 = t0 - phi/omega; % Time when x reaches maximum

% Energy conservation: Work done by external force in one cycle 
% equals energy dissipated by damping force
% P = deltaWork/deltaTime = F(t)deltaX/deltaTime = F(t)v(t)
Pt = Ft * vt; % Power = P(t)
theta = phi + pi/2; % Phase diff between F and v

% Average power, cos(theta) is called power factor
%Pavg = (A * omega * F0 * cos(theta)) / 2;
Pavg = gamma * m * v_max^2;

Pavg_max = F0^2 / (4*gamma*m);

% Equation of motion with damping and periodic ext force
% m * d2x/dt2 = F_0 * sing(omega*t) - kx - R*dx/dt

% Steady state equation of motion
% x = A * sin(omega*t + phi)

% Full width at half power of resonance (FWHPR)
FWHPR = 2 * DELTA * omega;

% Quality factor (Q)
Q = omega0 / (2*DELTA*omega);

%% Part A (No Damping Disk)

% Goal is to measure the period of the system with ML
% Gather data from LoggerPro with "rotary sensor aka angle sensor" and
% ultrasonic position sensor.

tbl = readtable('Lab7_EvA1.txt');
xArr = tbl.Position; % mass position data
thetaArr = tbl.Angle2; % rotary arm angle data
tArr = tbl.Time; % time array (same for both x and theta)
omega = tbl.Velocity2; % Drive frequency (rad/s)
 
%% Position crossing times
% Identify corresponding peaks in both datasets (find peaks and make
% indices match.

% Find zero crossings of position with directions
[x_crossTimes, x_crossIndices, crossingDirections] = zeroCross2(xArr, tArr);

% Get positions at zero crossings of velocity
peak_positions = xArr(x_crossIndices);
peak_times = tArr(x_crossIndices);

% Separate maxima and minima based on crossing directions
max_indices = x_crossIndices(crossingDirections == -1);
min_indices = x_crossIndices(crossingDirections == 1);

max_positions = xArr(max_indices);
max_times = tArr(max_indices);

min_positions = xArr(min_indices);
min_times = tArr(min_indices);

% Combine maxima and minima
all_peak_times = [max_times; min_times];
all_peak_positions = [max_positions; min_positions];

% Calculate time difference between peaks in both datasets, match indices
% and find delta_t for corresponding index numbers.
% Calculate the mean of the delta t's and with that calculate
% Prepare Peak Data for Log Plotting
[sorted_times, sort_idx] = sort(all_peak_times);
sorted_amplitudes = abs(all_peak_positions(sort_idx));


%% Part C

% Use ML to make plots of A vs omega, vMax vs. omega, and phi vs. omega

% A vs. omega
figure(1);
plot(omega, A);

% vMax vs. omega
figure(2);
plot(omega, v_max);

% phi vs. omega
figure(3);
plot(omega, phi);



