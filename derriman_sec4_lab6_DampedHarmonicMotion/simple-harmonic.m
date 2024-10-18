% for pendulum or bobbing cylinder or similar

% SETTING UP DIFFERENTIAL EQUATION
% from d^2*y/dy^2 == y'' == (-g/d_0)y
% define omega = sqrt(g/d_0)
% y'' == -omega * y

% SETTING UP PERIOD OF OSCILLATION EQUATION
% we say that omega * some time tau makes a full oscillation cycle 2*pi
% thus, omega * tau == 2*pi and.
% tau == (2*pi)/omega

% NOTES AND THOUGHTS

% is the period inversely proportional to the time of oscillation tau?

g = 9.8; %meters/sec^2
d0 = 0.2; %meters

omega = sqrt(g/d0);
oscillation = 2*pi;

tau = oscillation/omega;


