% Define A_n function (Question 1, Square Wave)
An = @(n) -4./(n*pi) .* (-1).^((n+1)/2);

function f_reconstructed = fourierSeriesRecon_An(An, N, t)
    v0 = 1;
    % Initialize output
    f_reconstructed = zeros(size(t));
    
    % Loop through n values and sum up the series
    for n = -N:N
        if n ~= 0
            f_reconstructed = f_reconstructed + ...
                An(n) * exp(1i*2*pi*n*v0*t);
        end
    end
end

% Then to use it:
t = linspace(-2, 2, 1000);  % Time points
N = 10;  % Number of terms
f = fourierSeriesRecon_An(An, N, t);

% Plot the result
plot(t, real(f));