function T = Scale_PG(Sx, Sy)
%SCALE_50205008 - Calculate scale matrix in 2D space
%
% Syntax:  [ T ] = Scale_50205008(Sx, Sy)
%
% Inputs:
%    Sx - Scale along x-axis
%    Sy - Scale along y-axis
%
% Outputs:
%    T - Scale matrix in 2D space (3x3)

% Author: Payam GHASSEMI, Ph.D., Mechanical Engineering
% University at Buffalo
% Email Address: payamgha@buffalo.edu  
% Website: http://www.PayamGhassemi.com/
% February 2017

T = [ Sx,  0, 0;
       0, Sy, 0;
       0,  0, 1];