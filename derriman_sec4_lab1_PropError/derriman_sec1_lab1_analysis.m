%%%%%%%%%%%% 
% Lab1: Propagation of Error
% Section 1
% Kym Derriman (partner: Diego Juarez)
% Date: 09/12/2024
% Guided by "Lab 1: Propagation of Errors" document
%%%%%%%%%%%%

% First Round of Measured Data

% Length of Wire
L = 837/1000;
dL = .0005;

% Diameter of Wire
d = 0.4/1000;
dd = .0001;

% Mass of Block
m = 237.1/1000;
dm = .0002;

% Width of Block
a = 19.4/1000;
da = .0002;

% Length of Block
b = 124.9/1000;
db = .0002;

% Rotation period (oscillation) of block, one measurement taken
T = 3.96;
dT = .5;

% Calculate the moment of inertia 
I = m/12 * (a^2 + b^2);
fprintf('I = %10.5g (kg m^2) \n', I)

% Define Modulus of Rigidity Function
f_modulus = @(L, m, a, b, d, T) 32/3*pi*L*m*(a^2 + b^2)/(d^4 * T^2);

% taking M out of the partial derivatives- updated
dm_per_M = @(L, dL, m, dm, a, da, b, db, d, dd, T, dT) ... 
                 [dL/L, dm/m, 2*a*da/(a^2+b^2), 2*b*db/(a^2+b^2), 4*dd/d, 2*dT/T];

% 1. Oscillation T (original)
fprintf('T_original = %10.5g +- %10.5g \n', T, dT);

% 2. Best estimate of Modulus of Rigidity (original)
fprintf('M_original = %10.5g \n', f_modulus(L, m, a, b, d, T));

% 3. Individual error contributing to dM/M (original)
fprintf(' _dL = %10.5g \n _dm = %10.5g \n _da = %10.5g \n _db = %10.5g \n _dd = %10.5g \n _dT = %10.5g \n',...
    dm_per_M(L, dL, m, dm, a, da, b, db, d, dd, T, dT));

% 4. dM/M from quadratic sum of all the error elements (original)
fprintf('dM/M = sqrt(_dL^2 + _dm^2 + _da^2 + _db^2 + dd^2 + dT^2) = %10.5g \n',...
    norm(dm_per_M(L, dL, m, dm, a, da, b, db, d, dd, T, dT)));



% It will be valuable to perform more measurements for the period and
% ...diameter.

% diameter more precise measurements
diam_array = [0.511, 0.513, 0.515, 0.513, 0.511, 0.514, 0.519, 0.512, 0.509, 0.514]/1000;
new_d = mean(diam_array);
% standard error diameter
new_dd = std(diam_array);

% we measured the period with stopwatch over 10 oscillations 
T_array = [3.887 3.882 3.892];
new_T = mean(T_array);
% standard error for oscillations
new_dT = std(T_array);

% Modulus of rigidity recalculated given updated measurements

new_mod_f = @(L, m, a, b, d, T) 32/3*pi*L*m*(a^2 + b^2)/(new_d^4 * new_T^2);

% taking M out of the partial derivatives- updated
new_dm_per_M = @(L, dL, m, dm, a, da, b, db, d, dd, T, dT) ... 
    [dL/L, dm/m, 2*a*da/(a^2+b^2), 2*b*db/(a^2+b^2), 4*new_dd/new_d, 2*new_dT/new_T];

%%%%%%%%%%%
% Results
%%%%%%%%%%%


fprintf('\n Updated Results \n')

% 1. Oscillation T 
fprintf('T = %10.5g +- %10.5g \n', new_T, new_dT);

% 2. Best estimate of Modulus of Rigidity 
fprintf('M = %10.5g \n', new_mod_f(L, m, a, b, new_d, new_T));

% 3. Individual error contributing to dM/M 
fprintf(' _dL = %10.5g \n _dm = %10.5g \n _da = %10.5g \n _db = %10.5g \n _dd = %10.5g \n _dT = %10.5g \n',...
    new_dm_per_M(L, dL, m, dm, a, da, b, db, new_d, new_dd, new_T, new_dT));

% 4. dM/M from quadratic sum of all the error elements
fprintf('dM/M = sqrt(_dL^2 + _dm^2 + _da^2 + _db^2 + new_dd^2 + new_dT^3) = %10.5g \n',...
    norm(new_dm_per_M(L, dL, m, dm, a, da, b, db, new_d, new_dd, new_T, new_dT)));