function [f_reconstructed, fn_coefficients] = fourierSeriesRecon(f_original, T, N, t)
% FOURIERSERIESRECON Reconstructs a function using Fourier series
%
% Inputs:
%   f_original: Function handle of the original function
%   T: Period of the function
%   N: Number of Fourier coefficients to compute (-N to N)
%   t: Time vector for reconstruction
%
% Outputs:
%   f_reconstructed: Reconstructed function values
%   fn_coefficients: Fourier series coefficients

    % Fundamental frequency
    v0 = 1/T;
    
    % Initialize arrays
    fn_coefficients = zeros(2*N + 1, 1);
    f_reconstructed = zeros(size(t));
    
    % Calculate Fourier coefficients
    for n = -N:N
        % Index for storing coefficients (shifted by N+1 for 1-based indexing)
        idx = n + N + 1;
        
        % Calculate nth Fourier coefficient using numerical integration
        integrand = @(tau) f_original(tau) .* exp(-1i*2*pi*n*v0*tau);
        fn_coefficients(idx) = (1/T) * integral(integrand, -T/2, T/2);
    end
    
    % Reconstruct the function
    for n = -N:N
        idx = n + N + 1;
        f_reconstructed = f_reconstructed + ...
            fn_coefficients(idx) * exp(1i*2*pi*n*v0*t);
    end
end

% Example usage:
% Define a test function (e.g., square wave)
% f = @(t) (abs(t) <= 0.5);
% T = 2;  % Period
% N = 10; % Number of coefficients
% t = linspace(-1, 1, 1000);
% [f_recon, fn] = fourierSeriesRecon(f, T, N, t);
