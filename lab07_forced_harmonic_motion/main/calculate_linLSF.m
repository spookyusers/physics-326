% Perform linear least squares fit to model relationship between x and y

% Input:
%       x (array): independent variable data points
%       y (array): dependent variable data points
%       w (array): weights to each data point (typically 1/sigma^2)
% Output:
%       A: Estimated intercept of best fit line
%       B: Estimated slope of best fit line
%       sigmaA: Uncertainty (standard error) A
%       sigmaB: Uncertainty (standard error) B

function [A, B, sigmaA, sigmaB] = calculate_linLSF(x, y, w)

% Reshape the arrays into column vectors
x = x(:);
y = y(:);
w = w(:);

% Computes determinant of matrix involved in the normal equations of the
% weighted least-squares method.
Delta = sum(w) * sum(w .* (x .^ 2)) - (sum(w .* x) .^ 2);

% Perform the least-squares fit calculations for A (intercept) and B (slope)
A = (sum(w .* (x .^ 2)) * sum(w .* y) - sum(w .* x) * sum(w .* x .* y)) / Delta;
B = (sum(w) * sum(w .* x .* y) - sum(w .* x) * sum(w .* y)) / Delta;

% Calculate uncertainties (standard errors) for A and B
sigmaA = sqrt(sum(w .* (x .^ 2)) / Delta);
sigmaB = sqrt(sum(w) / Delta);

end

