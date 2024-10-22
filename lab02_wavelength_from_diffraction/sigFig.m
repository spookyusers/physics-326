%--------------------------
% Roud Error to Significant Figure
%--------------------------

% This function rounds an error or uncertainty 0<x<1 to the first
% significant figure.

function r = sigFig(x)
    % Makes sure to handle input of zero for x, which would otherwise cause
    % an error since log(0) is undefined.
    if x == 0
        r = 0;
        return;
    end

    % Compute the exponent (order of magnitude) of the significant digit in
    % x by taking the log_10 of the absolute value of x, then rounding down
    % (more negative) with the floor function. This tells you how many
    % decimal places to shift. This will be a negative number.
    exp = floor(log10(abs(x)));

    % Scale x to the exponent negative of the exponent value, which gives a
    % number between 1 - 10, the rounded whole number value of which is the
    % significant figure we are interested in obtaining.
    scaled = x * 10^(-exp);

    % Round the scaled number. This gives a single digit whole number, our
    % significant figure, just not in the right decimal place.
    rounded = round(scaled);

    % Do the inverse operation of the first scaling, which gives the
    % significant figure of the correct order of magnitude.

    r = rounded * 10^(exp);
end

