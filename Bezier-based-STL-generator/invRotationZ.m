%invRotationZ
% Author: Payam GHASSEMI, Ph.D., Mechanical Engineering
% University at Buffalo
% Email Address: payamgha@buffalo.edu  
% Website: http://www.PayamGhassemi.com/
% May 15, 2017 

function q = invRotationZ(p, m, b)
% p DxN
% P NxD
P = ones(size(p,2)+1, size(p,1));
P(1,:) = p(:,1)'; 
P(2,:) = p(:,2)'; 
P(3,:) = p(:,3)'; 
T = [1, 0, 0, 0;
     0, 1, 0, b;
     0, 0, 1, 0;
     0, 0, 0, 1];
 
% th in radian
th = atan2(m,1);
Rz = [cos(th), -sin(th), 0, 0;
      sin(th), cos(th), 0, 0;
      0, 0, 1, 0;
      0, 0, 0, 1];
M = T * Rz;
qDummy = M * P;
q = qDummy(1:end-1,:)';
size(q)