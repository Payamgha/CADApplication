function [P1 , P2] = BezierSegment(P, alpha)
% Author: Payam GHASSEMI, Ph.D., Mechanical Engineering
% University at Buffalo
% Email Address: payamgha@buffalo.edu
% April 23, 2017

% MAE577 CAD Application Course
% Homework 04, Segmentation a Bezier curve into two pieces

N = size(P, 1);
Px = zeros(N,N);
Py = zeros(N,N);
Px(1, :) = P(:,1)';
Py(1, :) = P(:,2)';
for i = 2:N
    for j = 1:N-i+1
        Px(i,j) = (1-alpha)*Px(i-1, j) + alpha*Px(i-1, j+1);
        Py(i,j) = (1-alpha)*Py(i-1, j) + alpha*Py(i-1, j+1);
    end
end
P1 = [ Px(:,1), Py(:,1) ];
P2 = [ diag(fliplr(Px')), diag(fliplr(Py')) ];

