function n = quatInverse(q)
%QUATINVERSE_50205008
%
% Syntax:  n = quatInverse_50205008(q)
%
% Inputs:
%    q  - Input quaternion, vector 4 by 1
%
% Outputs:
%    n  - Inversed quaternion, vector 4 by 1

% Author: Payam GHASSEMI, Ph.D., Mechanical Engineering
% University at Buffalo
% Email Address: payamgha@buffalo.edu  
% Website: http://www.PayamGhassemi.com/
% March 05, 2017 

n = zeros(4,1);
n(1) = q(1);
n(2:4) = -q(2:4);
