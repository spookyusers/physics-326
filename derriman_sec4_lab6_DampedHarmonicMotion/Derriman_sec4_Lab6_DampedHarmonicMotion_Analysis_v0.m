% Kym Derriman (Partner: Evan Howell)
% Lab 6: Damped Harmonic Motion
% 10/17/2024

%%
% -------------------------------------
% Spring Force vs Displacement Analysis
% -------------------------------------

% Import data
yArr = [];
yStds = [];
yStErr = [];
filename.Temp = "s4L6_%d.txt";
N_runs = 6;
sqrtN = sqrt(length(N_runs));

for i = 1:N_runs
    data = readtable(sprintf(filename.Temp, i));
    yData = data.Position;
    yArr = [yArr, mean(yData)];
    yStds = [yStds, std(yData)];
    yStErr = [yStErr, std(yData)/sqrt(length(yData))];
end

% Mass of weights
xArr = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5]; % in kg

g = 9.80; % acceleration due to gravity in m/s^2

% Calculated Force based on mass (F = m * g)
force = g .* xArr; % in Newtons (N)

% -------------------------------
% Calculate Slope (Spring Constant k)
% -------------------------------

[A1, B1, sigA1, sigB1] = lsqFit(xArr, yArr, 1 ./((yStErr).^2));

position = A1 + B1.*xArr;

k = -g/B1;
sigK = ((2*g)/((B1)^2))*sigB1;

% -------------------------------
% Plot: Position vs. Mass
% -------------------------------

figure; hold on; grid on; box on;

% Plot Position with error bars
errorbar(xArr, yArr, yStds, 'ro', 'MarkerSize',5, 'DisplayName','Position vs Mass');

% Title and Labels with Uncertainties
title('Position vs Mass', 'FontSize', 14);
xlabel('Mass (kg)', 'FontSize', 11);
ylabel('Position (m)', 'FontSize', 11);
legend('Location','northwest');
set(gca, 'FontSize', 12);

% Plot Linear Fit
x_fit = linspace(min(xArr)*0.95, max(yArr)*1.05, 100);
y_fit = B1 * xArr + A1;
plot(xArr, y_fit, 'k--', 'LineWidth', 2)%, 'DisplayName',sprintf('Fit: F = %.2f x + %.2f', B1, A1));


%%
% Part C

% Import 500g data
tbl = readtable("L6_500g_Oscillation.txt");
t = tbl.Time;
y = tbl.Position;
v = tbl.Velocity;
a = tbl.Acceleration;

%%

% Use position data and subtract the offset such that it
% oscillates around 0

yMean = mean(y);
vMean = mean(v);
aMean = mean(a);

y1 = y - yMean;
v1 = v - vMean;
a1 = a - aMean;
% 
% yNorm = y1./sqrt(ly1));
% vNorm = v1./sqrt(length(v1));
% aNorm = a1./sqrt(length(a1));

figure;
plot(t, y1);
figure;
plot(t, v1);
figure;
plot(t, a1);

Part E:
%%

% Step 10:

trs = 0.0028;
zero_crossings = t(abs(y1) < trs);
w = ones(length(zero_crossings), 1)*(1/30);


[A1, B2, sigA1, sigB1,] = lsqFit(1:length(zero_crossings), zero_crossings, w);
periodLSF = A1 + B1.*zero_crossings;

T = 2 * B2;
sigT = 2 * sigB1;


holderWeight = 99.1; % grams
springWeight = 29.2; % grams

% find 0 points, find values close to zero and look at order of magnitude
% and ... plot times and position data, see if it's a perfect line of if
% you missed some, there will be a jump in the data