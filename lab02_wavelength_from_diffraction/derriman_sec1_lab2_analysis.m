%{
Lab 2: Measuring Wavelength of Light with Steel Ruler
Section 1
Kym Derriman (partner: Diego Juarez)
Date: 09/19/2024
%}

%{
Wavelength (lambda) in terms of maxima separation (h's),
slit width (d), distance diffracted light to screen (L),
and integer number of maxima (n).
%}
lambda = @(d,L,h0,hn,n) ((d / (2*L^2)) * (hn.^2 - h0 * hn))./n;

%{
Partial derivatives with respect to wavelength (lambda) of 
length (L), maxima separation (hn's), first maxima (h0). In this
calculation, slit width is assumed exact and error of hn assumed
to be (5*10^-4).
%}

dlam_dL = @(d,L,h0,hn,n) -(d * (hn.^2 - h0 .* hn)) ./ (L.^3 .* n);
dlam_dhn = @(d,L,h0,hn,n) (d * (2*hn - h0)) ./ (2*L.^2 .*n);
dlam_dh0 = @(d,L,hn,n) -(d .*hn) ./(2 * L.^2 .*n);

%%%%%%%%%%%%%%%%
% 1/64" Measurements and Uncertainties
%%%%%%%%%%%%%%%%

% Length (cm) from reflection point on ruler to screen
Ls = [189.2 188.1 187.5 186.3 186.1]/100; % /100 for meter conversion
L = mean(Ls); % best guess L
dL = std(Ls)/sqrt(numel(Ls)); % standard deviation L
dlam_dL_64_values = dlam_dL(d,L,h0,hn,n); % partial L, returns array

% h0 (cm) measurements from reference point on screen to first maxima
h0s = [8.4, 8.5, 8.4]/100; % /100 for meter conversion
h0 = mean(h0s); % best guess h0
dh0 = std(h0s)/sqrt(numel(h0s)); % standard deviation h0
dlam_dh0_values = dlam_dh0(d,L,hn,n); % partial h0, returns array

% hn's (cm): measurements from reference point to subsequent maxima
h_1 = [15.4, 15.4, 15.4]/100;
h_2 = [19.1, 19.5, 19.6]/100;
h_3 = [23, 22.9, 23.0]/100;
h_4 = [25.6, 25.6, 25.7]/100;
hns = [mean(h_1), mean(h_2), mean(h_3), mean(h_4)]; % mean hn values

% Partial hn for 1/64"
d_hn_64 = dlam_dhn(d,L,h0,hn,n);

% Integer count
n = [1, 2, 3, 4];


% 1/64" width diffraction grating "slits," which are ruler markings
d =(1/64*2.54)/100; % convert: inches to meters


% Define wavelength (labmda) uncertainty in the form of:
% uncertainty = sqrt((partial_a * d_a)^2 + (partial_b * d_b)^2 ...)
d_lambda = @(d_lam_dL,dL,d_lam_dhn,dhn,d_lam_dh0,dh0)...
    sqrt(...
    (d_lam_dL * dL)^2 +...
    (d_lam_dhn * dhn)^2 +...
    (d_lam_dh0 *dh0)^2);

%{
RESULTS FOR 1/64"
%}

lambda_64 = lambda(d,L,h0,hn,n);
uncert_64 = d_lambda(dlam_dL,dL,dlam_dhn,dhn,dlam_dh0,dh0);

fprintf('Wavelength = %10.5g +_ %10.5g (m)',lambda_64,uncert_64)
    
