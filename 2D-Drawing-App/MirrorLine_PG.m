function T = MirrorLine_PG(m, b)
%MIRRORLINE_50205008 - Calculate mirror matrix w.r.t. an arbitrary line in 2D space
% 
% Syntax:  [ T ] = MirrorLine_50205008(m, b)
%
% Inputs:
%    m - Slope line (y = mx + b)
%    b - y-intercept (y = mx + b)
%
% Outputs:
%    T - Mirror matrix w.r.t an arbitrary line in 2D space (3x3)

% Author: Payam GHASSEMI, Ph.D., Mechanical Engineering
% University at Buffalo
% Email Address: payamgha@buffalo.edu  
% Website: http://www.PayamGhassemi.com/
% February 2017

angle = rad2deg(atan(m));
T1  = Translation_PG(0, -b);
R1  = Rotation_PG(angle);
Mr  = Mirror_PG(1);
R1n  = Rotation_PG(-angle);
T1n  = Translation_PG(0, b);
T = T1n * R1n * Mr * R1 * T1;