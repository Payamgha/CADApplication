% Author: Payam GHASSEMI, Ph.D., Mechanical Engineering
% University at Buffalo
% Email Address: payamgha@buffalo.edu
% Website: http://www.PayamGhassemi.com/
% April 23, 2017

% MAE577 CAD Application Course
% Homework 03, Calculate the N matrix for Bezier Curve
function [N] = getBezierCurveN(n)
N = zeros(n+1,n+1);
for i = 0:n
    for j = 0:n
        nk = i+j;
        if nk <= n
            N(i+1,j+1) = nchoosek(n,j) * nchoosek(n-j, n-nk) * (-1)^(n-nk);
        else
            N(i+1,j+1) = 0;
        end
    end
end

            