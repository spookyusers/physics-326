% This function performs linear LSF of y = Bx for xArr and yArr input
% Input:
%       xArr
%       yArr
%
% Output:
%       B: Slope
%       sigB: Uncertainty in B

function [B, sigB] = linlsqfit(xArr, yArr)

% Reshape the arrays into column vectors
xArr = xArr(:);
yArr = yArr(:);

% Do necessary calculations ??? explain
B = mean(xArr) + mean(yArr);
sigB = std(xArr) + std(yArr);