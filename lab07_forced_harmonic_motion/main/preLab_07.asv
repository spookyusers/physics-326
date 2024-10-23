% PreLab Work Lab 07 Forced Harmonic Motion
% Kym Derriman

%% Tracking variables and equations from manual

L = 123; % Equilibrium point
m = 134; % Mass
x0 = 234; % Displacement
t = linspace(1,30,900); % Time (sample array)
R = 123; % Damping constant
omega = 123; % Driving frequency of external force

omega0 = sqrt(k/m); % Resonant frequency
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
v_max = omega * A;

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

tbl = readtable('partA1.txt');
xArr = tbl.Position; % mass position data
thetaArr = tbl.Angle; % rotary arm angle data
tArr = tbl.Time; % time array (same for both x and theta)

omega = 5; % Drive frequency (rad/s)

% Identify corresponding peaks in both datasets (find peaks and make
% indices match.
% Calculate time difference between peaks in both datasets, match indices
% and find delta_t for corresponding index numbers.
% Calculate the mean of the delta t's and with that calculate


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



