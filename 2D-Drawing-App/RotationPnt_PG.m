function T = RotationPnt_PG(angle, px, py)
%ROTATIONPNT_50205008 - Calculate rotation matrix around an arbitrary point in 2D space
%
% Syntax:  [ T ] = RotationPnt_50205008(angle, px, py)
%
% Inputs:
%    angle - Rotation angle in degree (+: CCW)
%    px - Rotation point in x-axis
%    py - Rotation point in y-axis
%
% Outputs:
%    T - Rotatiation matrix around an arbitrary point in 2D space (3x3)

% Author: Payam GHASSEMI, Ph.D., Mechanical Engineering
% University at Buffalo
% Email Address: payamgha@buffalo.edu  
% Website: http://www.PayamGhassemi.com/
% February 2017

T1 = [ 1, 0, -px;
       0, 1, -py;
       0, 0,   1];

T2 = [ 1, 0, px;
       0, 1, py;
       0, 0,  1];

R = Rotation_PG(angle);

T = T2 * R * T1;