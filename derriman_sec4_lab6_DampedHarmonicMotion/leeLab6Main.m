% This is a main Matlab script.
% It calls two functions 'linlsq1_lee' to perform
% linear regression model fit y = Bx

disp('Calling function linlsq1_lee to perform y = Bx fit');

massArr = []; % Mass in kg
dispArr = []; % Displacement in meters

% Linear fitting
[B, sigB] = linlsqfit1_lee(massArr, dispArr);

fprintf('B = %g \n', B);
fprintf('sigB = %g \n', sigB);