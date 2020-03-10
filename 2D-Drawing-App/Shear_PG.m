function T = Shear_PG(axis, angle)
%SHEAR_50205008 - Calculate shear matrix in 2D space
%
% Syntax:  [ T ] = Shear_50205008(axis, angle)
%
% Inputs:
%    axis  - 1: x-axis, 2: y-axis
%    angle - Shear along x/y-axis
% Outputs:
%    T - Shear matrix in 2D space (3x3)

% Author: Payam GHASSEMI, Ph.D., Mechanical Engineering
% University at Buffalo
% Email Address: payamgha@buffalo.edu  
% Website: http://www.PayamGhassemi.com/
% February 2017

if (axis == 1)
    T = [ 1, cotd(angle), 0;
        0, 1, 0;
        0, 0, 1];
else
    T = [ 1, 0, 0;
        cotd(angle), 1, 0;
        0, 0, 1];
end
