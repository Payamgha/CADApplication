function T = Mirror_PG(axis)
%MIRROR_50205008 - Calculate mirror matrix in 2D space
%
% Syntax:  [ T ] = Mirror_50205008(axis)
%
% Inputs:
%    axis - Mirror axis selection (1: x-axis, 2: y-axis)
%
% Outputs:
%    T - Mirror matrix in 2D space (3x3)

% Author: Payam GHASSEMI, Ph.D., Mechanical Engineering
% University at Buffalo
% Email Address: payamgha@buffalo.edu  
% Website: http://www.PayamGhassemi.com/
% February 2017

if ( axis == 1 )
    T = [ 1,  0, 0;
          0, -1, 0;
          0,  0, 1];
elseif( axis == 2 )
    T = [ -1, 0, 0;
           0, 1, 0;
           0, 0, 1];
else
    error('Invalid input: input must be 1 or 2.');
end
        
        