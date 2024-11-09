% Lab 9 & 10 Fourier Analysis and Synthesis
% Kym Derriman (Partner: Evan Howell)
% 11/7/2024

%% Part 1: Questions

% Calculate the fourier coefficients 
% Equation (3): f(t)=SUM from -inf to inf of hat(f_n) * exp(i*2*pi*n*v0*t)
%               hat(f_n) = (1/T)*integr(-T/2,T/2) of
%                           f(t)*exp(-i*2*pi*n*v0*t)dt
% Question 1: Calculate hat(f_n) for the square wave using (3)
%   Square Wave: A_n == -(4/n*pi)*(-1)^((n+1)/2) for n odd; else zero
% Use defined functions (saved).
An = @(n) -(4/n).*pi.*(-1).^((n+1)/2);



% T = 2;  % Period
% N = 10; % Number of coefficients
% t = linspace(-1, 1, 1000);
% [f_recon, fn] = fourierSeriesRecon(f, T, N, t);