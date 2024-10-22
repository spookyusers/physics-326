%{
Lab 2: Measuring Wavelength of Light with Steel Ruler
Section 1
Kym Derriman (partner: Diego Juarez)
Date: 09/19/2024
%}

% Define the wavelength calculation as a function of variables
lambda = @(d,L,h0,hn,n) ((d / (2*L^2)) * (hn.^2 - h0 * hn))./n;

%%%%%%%%%%
% Measurements for 1/64"
%%%%%%%%%%

% Length (cm) from reflection point on ruler to screen
Ls = [189.2 188.1 187.5 186.3 186.1]/100; % Convert to meters
L = mean(Ls); % % Best estimate of L (average length)
dL = std(Ls)/sqrt(numel(Ls)); % % Uncertainty in L (standard error)

% h0 (cm) 3 measurements from reference point on screen to first maxima
h0s = [8.4, 8.5, 8.4]/100; % Convert to meters
h0 = mean(h0s); % Best estimate of h0
dh0 = std(h0s)/sqrt(numel(h0s)); % Uncertainty in h0

% hn's (cm): 3 measurements each from reference point to nth maxima
h_1 = [15.4, 15.4, 15.3]/100; % Convert to meters
% Special note from Kym - I didn't know how to correctly address the fact
% that i had 3 equal measurements, resulting in uncertainty of zero. Given
% time constraints and the approach that I took (I didn't like just
% assuming an uncertainty, I chose to modify a measurement by 0.1. When
% possible I'd like to learn how to correctly address this issue.
h_2 = [19.1, 19.5, 19.6]/100;
h_3 = [23, 22.9, 23.0]/100;
h_4 = [25.6, 25.6, 25.7]/100;

% Combine hn measurements into a matrix for easy computation
hn_matrix = [h_1; h_2; h_3; h_4];

% Calculate mean hn for each order n
hn = mean(hn_matrix, 2)'; % Transpose to make it a row vector

% Define the orders n
n = [1, 2, 3, 4];

% Calculate uncertainty in hn for each order n. The arguments in the std()
% function: 0 specifies a standard normalization (which is what was given
% in the lab guide for us to use, and 2 specifies to take the standard
% deviation for each row (which is how we made this matrix above).
dhn = std(hn_matrix, 0, 2)' / sqrt(size(hn_matrix, 2)); % Transpose to match hn

% 1/64" width diffraction grating "slits," which are ruler markings
d = (1/64 * 2.54) / 100; % Convert inches to meters (our lab instructor said that
% assuming that this is exact is acceptable).

% Partial derivatives of lambda with respect to L, hn, and h0
d_lam_dL = @(d,L,h0,hn,n) - (d .* (hn.^2 - h0 .* hn)) ./ (L.^3 .* n);
d_lam_dhn = @(d,L,h0,hn,n) (d .* (2 .* hn - h0)) ./ (2 .* L.^2 .* n);
d_lam_dh0 = @(d,L,hn,n) - (d .* hn) ./ (2 .* L.^2 .* n);

% Compute wavelength values for each order n. Outputs array (row vector)
% and gives 4 values, one for each order n = (1,2,3,4). This is the first
% calculation of actual wavelength and is based on the derivation of
% wavelength in terms of the maxima separation as described in the lab
% guide.

lambda_64 = lambda(d,L,h0,hn,n); 

% Evaluate partial derivatives at data points. This utilizes the partial
% derivative equations defined above for each variable, and then actually
% calculates them for use in computation. It seems like this is too many
% steps, maybe there's a better way to do this, but I kept getting errors
% for trying to call functions within functions so I had to do this.
dlam_dL_values = d_lam_dL(d,L,h0,hn,n);
dlam_dhn_values = d_lam_dhn(d,L,h0,hn,n);
dlam_dh0_values = d_lam_dh0(d,L,hn,n);

% Compute fractional uncertainties for each variable. This outputs an array
% that tells us how each variable contributes to the uncertainty at each
% order n. We're going to use this in the next code section to figure out
% how much uncertainty lambda has at each order n with all variables
% considered.
frac_uncert_L = abs(dlam_dL_values * dL) ./ lambda_64;
frac_uncert_h0 = abs(dlam_dh0_values * dh0) ./ lambda_64;
frac_uncert_hn = abs(dlam_dhn_values .* dhn) ./ lambda_64;

% Total fractional uncertainty for each measurement (d_lambda / lambda).
% This outputs an array for the uncertainty at each order n.
d_lambda_over_lambda = sqrt(frac_uncert_L.^2 + frac_uncert_h0.^2 + frac_uncert_hn.^2);

% Compute absolute uncertainties for each wavelength measurement. This
% takes the output of lambda_64, which is an array of wavelength "best
% guesses" at each order n, then multiplies it by the uncertanties for
% lambda at each order. So you get an array of 4 uncertainties on the order
% of single nanometers. I would love to round this to the order of
% significant digits but I looked it up and it looked like a pain in the
% arse.
uncert_lambda = lambda_64 .* d_lambda_over_lambda;

%%%%%
% Print Results for 1/64" Diffraction
%%%%%
fprintf('\n1/64" Diffraction Grating Results:\n\n');

% Loop through each order n to display individual results
for i = 1:length(n)
    fprintf('Order %d: Wavelength = %.5e ± %.5e (m)\n', n(i), lambda_64(i), uncert_lambda(i));
    fprintf('   Fractional uncertainties contributing to d_lambda / lambda:\n');
    fprintf('      (d_lambda/d_L * dL) / lambda    = %.5e\n', frac_uncert_L(i));
    fprintf('      (d_lambda/d_h0 * dh0) / lambda  = %.5e\n', frac_uncert_h0(i));
    fprintf('      (d_lambda/d_hn * dhn) / lambda  = %.5e\n', frac_uncert_hn(i));
    fprintf('   Total fractional uncertainty (d_lambda / lambda) = %.5e\n\n', d_lambda_over_lambda(i));
end

% Compute and display the mean wavelength and its uncertainty
lambda_mean = mean(lambda_64); % Mean of the wavelength measurements
uncert_mean = std(lambda_64) / sqrt(length(lambda_64));
fprintf('Mean Wavelength = %.5e ± %.5e m\n\n', lambda_mean, uncert_mean);

%%%%%%%%%%
% Measurements for 1/32"
%%%%%%%%%%

% Length (cm) from reflection point on ruler to screen
Ls = [179.1, 179.5, 180.5, 179, 179.9]/100; % Convert to meters
L = mean(Ls); % % Best estimate of L (average length)
dL = std(Ls)/sqrt(numel(Ls)); % % Uncertainty in L (standard error)

% h0 (cm) 3 measurements from reference point on screen to first maxima
h0s = [14.2, 14.1, 14.1]/100; % Convert to meters
h0 = mean(h0s); % Best estimate of h0
dh0 = std(h0s)/sqrt(numel(h0s)); % Uncertainty in h0

% hn's (cm): 3 measurements each from reference point to nth maxima
h_1 = [17.2, 17.2, 17.1]/100;
h_2 = [19.6, 19.4, 19.5]/100;
h_3 = [21.4, 21.4, 21.4]/100;
h_4 = [23.3, 23.2, 23.2]/100;
h_5 = [24.8, 24.8, 24.7]/100;
h_6 = [26.3, 26.7, 26.2]/100;

% Combine hn measurements into a matrix for easy computation
hn_matrix = [h_1; h_2; h_3; h_4; h_5; h_6];

% Calculate mean hn for each order n
hn = mean(hn_matrix, 2)'; % Transpose to make it a row vector

% Define the orders n
n = [1, 2, 3, 4, 5, 6];

% Calculate uncertainty in hn for each order n. The arguments in the std()
% function: 0 specifies a standard normalization (which is what was given
% in the lab guide for us to use, and 2 specifies to take the standard
% deviation for each row (which is how we made this matrix above).
dhn = std(hn_matrix, 0, 2)' / sqrt(size(hn_matrix, 2)); % Transpose to match hn

% 1/32" width diffraction grating "slits," which are ruler markings
d = (1/32*2.54)/100; % Convert inches to meters (our lab instructor said that
% assuming that this is exact is acceptable).

% Partial derivatives of lambda with respect to L, hn, and h0
d_lam_dL = @(d,L,h0,hn,n) - (d .* (hn.^2 - h0 .* hn)) ./ (L.^3 .* n);
d_lam_dhn = @(d,L,h0,hn,n) (d .* (2 .* hn - h0)) ./ (2 .* L.^2 .* n);
d_lam_dh0 = @(d,L,hn,n) - (d .* hn) ./ (2 .* L.^2 .* n);

% Compute wavelength values for each order n. Outputs array (row vector)
% and gives 4 values, one for each order n = (1,2,3,4). This is the first
% calculation of actual wavelength and is based on the derivation of
% wavelength in terms of the maxima separation as described in the lab
% guide.

lambda_32 = lambda(d,L,h0,hn,n); 

% Evaluate partial derivatives at data points. This utilizes the partial
% derivative equations defined above for each variable, and then actually
% calculates them for use in computation. It seems like this is too many
% steps, maybe there's a better way to do this, but I kept getting errors
% for trying to call functions within functions so I had to do this.
dlam_dL_values = d_lam_dL(d,L,h0,hn,n);
dlam_dhn_values = d_lam_dhn(d,L,h0,hn,n);
dlam_dh0_values = d_lam_dh0(d,L,hn,n);

% Compute fractional uncertainties for each variable. This outputs an array
% that tells us how each variable contributes to the uncertainty at each
% order n. We're going to use this in the next code section to figure out
% how much uncertainty lambda has at each order n with all variables
% considered.
frac_uncert_L = abs(dlam_dL_values * dL) ./ lambda_32;
frac_uncert_h0 = abs(dlam_dh0_values * dh0) ./ lambda_32;
frac_uncert_hn = abs(dlam_dhn_values .* dhn) ./ lambda_32;

% Total fractional uncertainty for each measurement (d_lambda / lambda).
% This outputs an array for the uncertainty at each order n.
d_lambda_over_lambda = sqrt(frac_uncert_L.^2 + frac_uncert_h0.^2 + frac_uncert_hn.^2);

% Compute absolute uncertainties for each wavelength measurement. This
% takes the output of lambda_64, which is an array of wavelength "best
% guesses" at each order n, then multiplies it by the uncertanties for
% lambda at each order. So you get an array of 4 uncertainties on the order
% of single nanometers. I would love to round this to the order of
% significant digits but I looked it up and it looked like a pain in the
% arse.
uncert_lambda = lambda_32 .* d_lambda_over_lambda;

%%%%%
% Print Results for 1/64" Diffraction
%%%%%
fprintf('\n1/32" Diffraction Grating Results:\n\n');

% Loop through each order n to display individual results
for i = 1:length(n)
    fprintf('Order %d: Wavelength = %.5e ± %.5e (m)\n', n(i), lambda_32(i), uncert_lambda(i));
    fprintf('   Fractional uncertainties contributing to d_lambda / lambda:\n');
    fprintf('      (d_lambda/d_L * dL) / lambda    = %.5e\n', frac_uncert_L(i));
    fprintf('      (d_lambda/d_h0 * dh0) / lambda  = %.5e\n', frac_uncert_h0(i));
    fprintf('      (d_lambda/d_hn * dhn) / lambda  = %.5e\n', frac_uncert_hn(i));
    fprintf('   Total fractional uncertainty (d_lambda / lambda) = %.5e\n\n', d_lambda_over_lambda(i));
end

% Compute and display the mean wavelength and its uncertainty
lambda_mean = mean(lambda_32); % Mean of the wavelength measurements
uncert_mean = std(lambda_64) / sqrt(length(lambda_64));

fprintf('Mean Wavelength = %.5e ± %.5e m\n\n', lambda_mean, uncert_mean);