function q = quaternion(u, p0, p, th)
%QUATERNION
%
% Syntax:  q = quaternion(u, p0, p, th)
%
% Inputs:
%    u  - Rotation axis, vector 3 by 1
%    p0 - Fixed point, vector 3 by 1
%    p  - Point that will be rotated, vector 3 by 1
%    th - Angle rotation in degree
%
% Outputs:
%    q - Vector 3 by 1

% Author: Payam GHASSEMI, Ph.D., Mechanical Engineering
% University at Buffalo
% Email Address: payamgha@buffalo.edu  
% Website: http://www.PayamGhassemi.com/
% March 03, 2017 

v = u./norm(u);
r = [cosd(th/2); sind(th/2).*(v)];
rInv = [cosd(th/2); -sind(th/2).*(v)];
pNew = zeros(4,1);
pNew(2:4) = p - p0;
p1 = quatmultiply(quatmultiply(r, pNew), rInv);
q = p1(2:4) + p0;
