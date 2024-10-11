%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Lab 1: Propagation of Errors
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Sang-Hyuk Lee (Partner: John Doe)
% Section: 1
% Date 09/09/2024
%--------------------------------------------

% Function definition of Modulus of Rigidity of wire: M
fun_M = @(L, m, a, b, d, T) 32/3*pi*L*m*(a^2 + b^2)/(d^4 * T^2);

% Fractional error of M: Individual elements for quadratic sum
fun_dM_over_M = @(L, dL, m, dm, a, da, b, db, d, dd, T, dT) ... 
                 [dL/L, dm/m, 2*a*da/(a^2+b^2), 2*b*db/(a^2+b^2), 4*dd/d, 2*dT/T]; 

%--------------------------------------------
% Measurement
%--------------------------------------------
% Wire length
L = 77.00 / 100; % wire length (meter)
dL = 0.05 / 100; % wire length uncertaintity (meter)

% Mass 
m = 234.40 / 1000; % mass (kg) 
dm = 0.05 / 1000; % mass uncertainty (kg)

% Block length
a = 114.40 / 1000; % block length (meter)
da = 0.05 / 1000; % block length uncertaintity (meter)

% Block width
b = 18.9 / 1000; % block length (meter)
db = 0.05 / 1000; % block length uncertaintity (meter)

% Wire width 
d = 0.51110 / 1000; % wire width (meter)
dd = 0.00005 / 1000; % wire width uncertaintity (meter)

% Period: Counted for 10 periods and then divided by 10 
T_array = [27.68, 37.43, 38.31, 38.93, 38.07, 38.00, 37.85, 37.91, 38.16, 38.00]/10;
T = mean(T_array); % oscillation period (s)
dT = std(T_array); % oscillation period uncertaintity (s)

%--------------------------------------------
% Print out results 
%--------------------------------------------
% 1. Oscillation T 
fprintf('T = %10.5g +- %10.5g \n', T, dT);

% 2. Best estimate of Modulus of Rigidity 
fprintf('M = %10.5g \n', fun_M(L, m, a, b, d, T));

% 3. Individual error contributing to dM/M 
fprintf(' _dL = %10.5g \n _dm = %10.5g \n _da = %10.5g \n _db = %10.5g \n _dd = %10.5g \n _dT = %10.5g \n', fun_dM_over_M(L, dL, m, dm, a, da, b, db, d, dd, T, dT));

% 4. dM/M from quadratic sum of all the error elements
fprintf('dM/M = sqrt(_dL^2 + _dm^2 + _da^2 + _db^2 + _dd^2 + _dT^2) = %10.5g \n', norm(fun_dM_over_M(L, dL, m, dm, a, da, b, db, d, dd, T, dT)));
