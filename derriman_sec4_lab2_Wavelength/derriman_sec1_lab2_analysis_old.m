

%%%%%
% Measurements 1/64" markings on steel ruler
%%%%%

% Define the wavelength (lambda) function:
% from n*lambda = d(sin(theta_i) - sin(theta_r)) , in terms of the 
% maxima (h_0, h_1, ... ,h_n), giving: 
% n*lambda = (d/2L^2) * ((h_n)^2 - h_n * h_0)
f_lambda_64 = @(d_64,L_64,h0_64,hn_64,n_64) (d_64 / (2*L_64^2)) * (hn_64.^2 - h0_64 * hn_64)./n_64 ;

% Define the wavelength (lambda) uncertainty function
d_lambda_64 = @(d_64,L_64,dL_64,h0_64,dh0_64,hn_64,dhn_64,n_64) ... 
    sqrt( ...
    ( ...
    ((d_64/L_64^3 .* n_64) .* (hn_64.^2 - h0_64.*hn_64)).*L_64).^2 +...
    (((d_64./(2*L_64^2.*n_64)).*(2.*hn_64 - h0_64)).*hn_64).^2 + ...
    (((d_64./(2*L_64^2 .* n_64)) .* (hn_64.^2 - hn_64)).*h0_64).^2) ;
% Length (cm) from reflection point on ruler to screen
Ls_64 = [189.2 188.1 187.5 186.3 186.1]/100; % /100 for meter conversion
L_64 = mean(Ls_64);
dL_64 = @(Ls_64) std(Ls_64)/sqrt(numel(Ls_64));

% Separation width of diffraction grating "slits," which are ruler markings
d_64 =(1/64*2.54)/100; % conversion imperial to metric, then /100 for meters

% h0 (cm) measurements from reference point on screen to first maxima
h0s_64 = [8.4, 8.5, 8.4]/100; % /100 for meter conversion
h0_64 = mean(h0s_64);
dh0_64 = @(h0s_64) std(h0s_64)/sqrt(numel(h0s_64));

% hn's (cm): measurements from reference point to subsequent maxima
h_1_64 = [15.4, 15.4, 15.4]/100;
h_2_64 = [19.1, 19.5, 19.6]/100;
h_3_64 = [23, 22.9, 23.0]/100;
h_4_64 = [25.6, 25.6, 25.7]/100;
dhn_64 = 5e-4;

hn_64 = [mean(h_1_64), mean(h_2_64), mean(h_3_64), mean(h_4_64)];
n_64 = [1, 2, 3, 4];

%%%%%
% Measurements 1/32" markings on steel ruler
%%%%%

% Define the wavelength (lambda) function
f_lambda_32 = @(d_32,L_32,h0_32,hn_32,n_32) (d_32 / (2*L_32^2)) * (hn_32.^2 - h0_32 * hn_32)./n_32 ;

% Define the wavelength (lambda) uncertainty function
d_lambda_32 = @(d_32,L_32,dL_32,h0_32,dh0_32,hn_32,dhn_32,n_32) ... 
    sqrt((((d_32/L_32^3 .* n_32) .* (hn_32.^2 - h0_32.*hn_32)).*L_32).^2 +...
    (((d_32./(2*L_32^2.*n_32)).*(2.*hn_32 - h0_32)).*hn_32).^2 + ...
    (((d_32./(2*L_32^2 .* n_32)) .* (hn_32.^2 - hn_32)).*h0_32).^2) ;

% Separation width of diffraction grating "slits," which are ruler markings
d_32 =(1/32*2.54)/100; % conversion imperial to metric, then /100 for meters

% Length (cm) from reflection point on ruler to screen
Ls_32 = [179.1, 179.5, 180.5, 179, 179.9]/100; % /100 for meter conversion
L_32 = mean(Ls_32);
dL_32 = @(Ls_32) std(Ls_32)/sqrt(numel(Ls_32));

% h0 (cm) measurements from reference point on screen to first maxima
h0s_32 = [14.2, 14.1, 14.1]/100; % /100 for meter conversion
h0_32 = mean(h0s_32);
dh0_32 = @(h0s_32) std(h0s_32)/sqrt(numel(h0s_32));

% hn's (cm): measurements from reference point to subsequent maxima
h_1_32 = [17.2, 17.2, 17.1]/100;
h_2_32 = [19.6, 19.4, 19.5]/100;
h_3_32 = [21.4, 21.4, 21.4]/100;
h_4_32 = [23.3, 23.2, 23.2]/100;
h_5_32 = [24.8, 24.8, 24.7]/100;
h_6_32 = [26.3, 26.7, 26.2]/100;
dhn_32 = 5e-4;

hn_32 = [mean(h_1_32), mean(h_2_32), mean(h_3_32), mean(h_4_32), mean(h_5_32), mean(h_6_32)];
n_32 = [1, 2, 3, 4, 5, 6];

%%%%%
% Results 1/32"
%%%%%

% Define best estimate of wavelength from 1/32" ticks
best_lambda_32 = mean(f_lambda_32(d_32,L_32,h0_32,hn_32,n_32));

% Define uncertainty from 1/32" ticks
uncert_32 = mean(d_lambda_32(d_32,L_32,dL_32,h0_32,dh0_32,hn_32,dhn_32,n_32));

fprintf('Best estimate of laser wavelength from 1/32 inch \ndiffraction = %10.5g +- %10.5g (m) \n',best_lambda_32,uncert_32)

%%%%%
% Results 1/64"
%%%%%

% Define best estimate of wavelength from 1/64" ticks
best_lambda_64 = mean(f_lambda_64(d_64,L_64,h0_64,hn_64,n_64));

% Define uncertainty from 1/64" ticks
uncert_64 = mean(d_lambda_64(d_64,L_64,dL_64,h0_64,dh0_64,hn_64,dhn_64,n_64));

fprintf('Best estimate from 1/64 inch \ndifrraction = %10.5g +_ %10.5g (m)\n',best_lambda_64, uncert_64)
