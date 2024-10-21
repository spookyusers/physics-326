% -----------------------------------------------------------------
% Compare Measured Period with Theoretical Value
% -----------------------------------------------------------------

% Mass of weight holder, weight, and spring (1/3 * spring mass), g to kg
mass_holder = 99.1 / 1000;  
mass_weight = 500 / 1000;  
mass_spring_eff = 29.2 / 1000;

% Total mass for theoretical calculation
total_mass = mass_holder + mass_spring_eff + mass_weight;

% Calculate theoretical value of T with T = 2 * pi * sqrt(m / k)
T_theoretical = 2 * pi * sqrt(total_mass / k);
sigma_T_theoretical = T_theoretical * (sigk / (2 * k));

% Print Results for Measured vs Theoretical Period
fprintf('----------------------------------------------------------\n');
fprintf('Average Period of Oscillation (T) = %.3f ± %.4f seconds\n', average_period_pos, sigmaT_pos);
fprintf('Theoretical Period (T) = %.3f ± %.4f seconds\n', T_theoretical, sigma_T_theoretical);
fprintf('----------------------------------------------------------\n');

% Compare Measured Period with Theoretical
if abs(average_period_pos - T_theoretical) <= (sigmaT_pos + sigma_T_theoretical)
    fprintf('The measured period is within the uncertainty bounds of the\ntheoretical value.\n');
else
    fprintf('The measured period deviates significantly from the\ntheoretical value. Possible reasons: damping, spring imperfections, or noise.\n');
end
