function T = Translation_PG(dx, dy)
%TRANSLATION_50205008 - Calculate translation matrix in 2D space
%
% Syntax:  [ T ] = Translation_50205008(dx, dy)
%
% Inputs:
%    dx - Translation in x-axis
%    dy - Translation in y-axis
%
% Outputs:
%    T - Translation matrix in 2D space (3x3)

% Author: Payam GHASSEMI, Ph.D., Mechanical Engineering
% University at Buffalo
% Email Address: payamgha@buffalo.edu  
% Website: http://www.PayamGhassemi.com/
% February 2017

T = [ 1, 0, dx;
      0, 1, dy;
      0, 0,  1];
