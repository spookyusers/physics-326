%{
Lab 2: Measuring Wavelength of Light with Steel Ruler
Section 1
Kym Derriman (partner: Diego Juarez)
Date: 09/19/2024
%}

% --- Main Script ---

% --- 1/64" Measurements ---
d_64 = (1/64 * 2.54) / 100; % Convert inches to meters
Ls_64 = [189.2, 188.1, 187.5, 186.3, 186.1] / 100; % Convert to meters
h0s_64 = [8.4, 8.5, 8.4] / 100; % Convert to meters
h_1_64 = [15.4, 15.4, 15.3] / 100; % Convert to meters
h_2_64 = [19.1, 19.5, 19.6] / 100; % Convert to meters
h_3_64 = [23.0, 22.9, 23.0] / 100; % Convert to meters
h_4_64 = [25.6, 25.6, 25.7] / 100; % Convert to meters
hn_matrix_64 = [h_1_64; h_2_64; h_3_64; h_4_64];
n_values_64 = [1, 2, 3, 4];

% Call the function for 1/64" measurements
compute_wavelength(d_64, Ls_64, h0s_64, hn_matrix_64, n_values_64, '1/64" Diffraction Grating Results');

% --- 1/32" Measurements ---
d_32 = (1/32 * 2.54) / 100; % Convert inches to meters
Ls_32 = [179.1, 179.5, 180.5, 179.0, 179.9] / 100; % Convert to meters
h0s_32 = [14.2, 14.1, 14.1] / 100; % Convert to meters
h_1_32 = [17.2, 17.2, 17.1] / 100; % Convert to meters
h_2_32 = [19.6, 19.4, 19.5] / 100; % Convert to meters
h_3_32 = [21.4, 21.4, 21.4] / 100; % Convert to meters
h_4_32 = [23.3, 23.2, 23.2] / 100; % Convert to meters
h_5_32 = [24.8, 24.8, 24.7] / 100; % Convert to meters
h_6_32 = [26.3, 26.7, 26.2] / 100; % Convert to meters
hn_matrix_32 = [h_1_32; h_2_32; h_3_32; h_4_32; h_5_32; h_6_32];
n_values_32 = [1, 2, 3, 4, 5, 6];

% Call the function for 1/32" measurements
compute_wavelength(d_32, Ls_32, h0s_32, hn_matrix_32, n_values_32, '1/32" Diffraction Grating Results');
