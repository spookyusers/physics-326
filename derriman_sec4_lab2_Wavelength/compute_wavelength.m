%{

Function to calculate the wavelength of light incident upon a diffraction
grating utilizing several measured values.

---Output---

- Fractional uncertainties from each measured value contributing to 
uncertainty in lambda.
- Total fractional uncertainty (square root of the sum of the squares of
individual fractional uncertainties).
- Wavelength measurement at each maxima order with uncertainties.
- Mean wavelength across all maxima with uncertainty.

---Inputs---

- Slit width (d): This can be slits or grating width.
- Length (Ls): This is the distance from the point of diffraction to screen
as an array of measurements.
- First Bright Spot (h0): This is the distance from a reference point (a
point marked on the screen indicating the spot where the light source
shines when no obstructions are in the light path, to the central bright
spot, order n = 0. Input takes an array.
- nth Order Maxima (hn_matrix): Distance on screen from reference point to nth 
order maxima or bright spots as a matrix with multiple measurements where
each row represents a maxima order and columns are the measurements.
- Order Count (n_values): An array or row vector with integers representing
the number of maxima measured (not including h0). For example, if one
measures the four bright spots after the central h0 bright spot, n_values
should be [1,2,3,4].
- Title (title_str): Takes a string as input which displays at the
beginning of the output.

%}

% --- Function Definition ---

function compute_wavelength(d, Ls, h0s, hn_matrix, n_values, title_str)
    % Compute best estimates and uncertainties
    L = mean(Ls); % Best estimate of L
    dL = std(Ls) / sqrt(numel(Ls)); % Uncertainty in L

    h0 = mean(h0s); % Best estimate of h0
    dh0 = std(h0s) / sqrt(numel(h0s)); % Uncertainty in h0

    hn = mean(hn_matrix, 2)'; % Best estimates of hn for each order n
    dhn = std(hn_matrix, 0, 2)' / sqrt(size(hn_matrix, 2)); % Uncertainties in hn

    % Wavelength function
    lambda = @(d,L,h0,hn,n) ((d / (2*L^2)) * (hn.^2 - h0 * hn)) ./ n;

    % Calculate wavelength values
    lambda_values = lambda(d,L,h0,hn,n_values);

    % Partial derivatives
    d_lam_dL = - (d .* (hn.^2 - h0 .* hn)) ./ (L.^3 .* n_values);
    d_lam_dhn = (d .* (2 .* hn - h0)) ./ (2 .* L.^2 .* n_values);
    d_lam_dh0 = - (d .* hn) ./ (2 .* L.^2 .* n_values);

    % Fractional uncertainties
    frac_uncert_L = abs(d_lam_dL * dL) ./ lambda_values;
    frac_uncert_h0 = abs(d_lam_dh0 * dh0) ./ lambda_values;
    frac_uncert_hn = abs(d_lam_dhn .* dhn) ./ lambda_values;

    % Total fractional uncertainty
    d_lambda_over_lambda = sqrt(frac_uncert_L.^2 + frac_uncert_h0.^2 + frac_uncert_hn.^2);

    % Absolute uncertainties
    uncert_lambda = lambda_values .* d_lambda_over_lambda;

    % Print Results
    fprintf('\n%s:\n\n', title_str);
    for i = 1:length(n_values)
        fprintf('Order %d: Wavelength = %.5e ± %.5e m\n', n_values(i), lambda_values(i), uncert_lambda(i));
        fprintf('   Fractional uncertainties contributing to d_lambda / lambda:\n');
        fprintf('      (d_lambda/d_L * dL) / lambda    = %.5e\n', frac_uncert_L(i));
        fprintf('      (d_lambda/d_h0 * dh0) / lambda  = %.5e\n', frac_uncert_h0(i));
        fprintf('      (d_lambda/d_hn * dhn) / lambda  = %.5e\n', frac_uncert_hn(i));
        fprintf('   Total fractional uncertainty (d_lambda / lambda) = %.5e\n\n', d_lambda_over_lambda(i));
    end

    % Compute and display the mean wavelength and its uncertainty
    lambda_mean = mean(lambda_values);
    uncert_mean = sqrt(sum(uncert_lambda.^2)) / length(uncert_lambda);
    fprintf('Mean Wavelength = %.5e ± %.5e m\n\n', lambda_mean, uncert_mean);
end
