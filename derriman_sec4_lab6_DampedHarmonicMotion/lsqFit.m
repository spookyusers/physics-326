% Perform least squares fit (linear regression)
% This function performs linear LSF of y = Bx for xArr and yArr input
% Input:
%       xArr
%       yArr
% Output:
%       B: Slope
%       sigB: Uncertainty in B

function [A, B, sigA, sigB] = lsqFit(xArr, yArr, w)

% Reshape the arrays into column vectors
xArr = xArr(:);
yArr = yArr(:);
w = w(:);

Delta = sum(w).*sum(w.*(xArr .^2))-(sum(w.*xArr).^2);

A = ((sum(w.*(xArr.^2)).*(sum(w.*yArr))-(sum(w.*xArr)) ...
    .*(sum(w .* xArr .* yArr))))./ Delta;

B = ((sum(w)).*(sum(w.*xArr.*yArr))...
    - (sum(w.*xArr)).*(sum(w.*yArr)))./ Delta;

sigA = sqrt(sum(w .* xArr.^2) / Delta);
sigB = sqrt(sum(w) / Delta);
end
