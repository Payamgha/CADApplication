function n = quatmultiply(a, b)
%QUATMULTIPLY
%
% Syntax:  n = quatmultiply(a, b)
%
% Inputs:
%    a  - quaternion, vector 4 by 1
%    b  - quaternion, vector 4 by 1
%
% Outputs:
%    n  - quaternion, vector 4 by 1

% Author: Payam GHASSEMI, Ph.D., Mechanical Engineering
% University at Buffalo
% Email Address: payamgha@buffalo.edu  
% Website: http://www.PayamGhassemi.com/
% March 05, 2017 

n = zeros(4,1);
n(1) = a(1)*b(1) - a(2:4)'*b(2:4);
n(2:4) = a(1)*b(2:4) + b(1)*a(2:4) + cross(a(2:4),b(2:4));