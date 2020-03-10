function T = Rotation_PG(angle)
%ROTATION_50205008 - Calculate rotation matrix in 2D space
%
% Syntax:  [ T ] = Rotation_50205008(angle)
%
% Inputs:
%    angle - Angle in degree (+: CW)
%
% Outputs:
%    T - Rotation matrix in 2D space (3x3)

% Author: Payam GHASSEMI, Ph.D., Mechanical Engineering
% University at Buffalo
% Email Address: payamgha@buffalo.edu  
% Website: http://www.PayamGhassemi.com/
% February 2017

T = [ cosd(angle), sind(angle), 0;
     -sind(angle), cosd(angle), 0;
                0,           0, 1];
