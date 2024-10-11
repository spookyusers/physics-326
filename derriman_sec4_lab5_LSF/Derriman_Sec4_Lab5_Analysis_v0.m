%%
% part A-D is setup and collection only
%-----------------------------------------------
% PART E_1: import data for first run bg radiation
%-----------------------------------------------

% Import and extract data as table from text file
tbl = readtable('sec4_lab5_partB.txt');

% Extract 'Time' column data and assign it to an array
T_arr = tbl.Time;  

% Extract 'Radiation' column data and assign it to an array
D_b1arr = tbl.Radiation; 

% Time interval 
delta_t = 10;

% Total time for a run
sample_t = 600;

% Number of single acquisitions of radiation counts (600 s / 10 s)
num_data = sample_t / delta_t;

% Mean of decay events per sample
D_b1 =  mean(D_b1arr);

% Standard deviation of mean of N
Sigma_N =  std(D_b1arr) / sqrt(length(D_b1arr));

% Print results for best estimate and SDOM background radiation
fprintf("Distribution BG radiation before Ba-137 Decay:\n")
fprintf("Best estimate D_b1 = %10.2f ± %10.2f counts/s\n", D_b1, Sigma_N)

%%

%-----------------------------------------------
% PART E_2: import data for second run bg radiation
%-----------------------------------------------

% Import and extract data as table from text file
tbl = readtable('sec4_lab5_partD.txt');

% Extract 'Time' column data and assign it to an array
T_arr = tbl.Time;  

% Extract 'Radiation' column data and assign it to an array
D_b2arr = tbl.Radiation; 

% Time interval 
delta_t = 10;

% Total time for a run
sample_t = 600;

% Number of single acquisitions of radiation counts (600 s / 10 s)
num_data = sample_t / delta_t;

% Mean of decay events per sample
D_b2 =  mean(D_b2arr);

% Standard deviation of mean of N
Sigma_Db =  std(D_b2arr) / sqrt(length(D_b2arr));

% Print results for best estimate and SDOM background radiation
fprintf("Distribution BG radiation after Ba-137 Decay:\n")
fprintf("Best estimate D_b2 = %10.2f ± %10.2f counts/s\n", D_b2, Sigma_Db)

%%

% PART E_3: Calculate D = D* - D_b using D_b2 as D_b

% Import and extract data as table from text file
tbl = readtable('sec4_lab5_partC.txt');
T_arr = tbl.Time;  % time column
Dstar = tbl.Radiation; % radiation column

% D = D* - D_b2
D = Dstar - D_b2; % subtract D_i* - D_b2
y = log(D);
n = length(Dstar);

delta_Dstar = D .^(1/2);
SDOM_D = std(Dstar) ./ n;

%delta_Ystar = sqrt(y);
%SDOM_Y = std(y) ./ n;

partialY_Dstar = (1 ./ (Dstar - D_b2) );
partialY_Db = ( 1 ./ (Dstar - D_b2)) .*-1;

sigma_D = sqrt( delta_Dstar .^2 +  SDOM_D .^2 );

sigma_Y = sqrt( ((partialY_Dstar .* delta_Dstar) .^2)...
    + ( (partialY_Db .* sigma_D) .^2 ));

%fprintf("Uncertainty D_i = %10.2f\n", sigma_Dstar);
%fprintf("Uncertainty y_i = %10.2f\n", sigma_Ystar);


%%

% PART F: Plot D vs t and lnD vs t
% --------------------------------

figure;


errorbar(T_arr, D, sigma_D);

%%

wi = 1 ./( sigma_Y .^2);

Delta = sum(wi) .* sum(wi .* (T_arr .^2)) - (...
    sum(wi .* T_arr) .^2);

A = (...
    (sum(wi .* (T_arr .^2)) .* (sum(wi .* y))...
    - (sum(wi .* T_arr)) .* (sum(wi .* T_arr .* y))))...
    ./ Delta;

B = (...
    (sum(wi)) .* (sum(wi .* T_arr .* y))...
    - (sum(wi .* T_arr)) .* (sum(wi .* y)))...
    ./ Delta;

figure;

hold on;

errorbar(T_arr,y, sigma_Y, 'r');
LSF = A + B.*T_arr;

plot(T_arr, LSF, 'b');

