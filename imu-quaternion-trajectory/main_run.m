% Author: Payam GHASSEMI, Ph.D., Mechanical Engineering
% University at Buffalo
% Email Address: payamgha@buffalo.edu  
% Website: http://www.PayamGhassemi.com/
% March 06, 2017 

% MAE577 CAD Application Course
% Project 02

clc; clear all; close all;
load('q.mat');

%% Part (1)
x = [0, 1, 0, 0]';
y = [0, 0, 1, 0]';
z = [0, 0, 0, 1]';

sC = 1;
A = [0 0 0]*sC;
B = [3 0 0]*sC;
C = [0 1 0]*sC;
D = [0 0 1]*sC;
E = [0 1 1]*sC;
F = [3 0 1]*sC;
G = [3 1 0]*sC;
H = [3 1 1]*sC;
P = [A;B;F;H;G;C;A;D;E;H;F;D;E;C;G;B];
 
n = size(q,1);
X = zeros(n,4);
Y = zeros(n,4);
Z = zeros(n,4);
t0 = 0;
dt = 0.01;
tf = dt*(n-1);
for i = 1:n
    qi = q(i,:)';
    iqi = quatInverse(qi);
    
    xNew = quatmultiply(quatmultiply(qi, x),iqi);
    X(i,:) = xNew';
    
    yNew = quatmultiply(quatmultiply(qi, y),iqi);
    Y(i,:) = yNew';
    
    zNew = quatmultiply(quatmultiply(qi, z),iqi);
    Z(i,:) = zNew';

    aNew(i,:) = quatmultiply(quatmultiply(qi, [0, A]'),iqi);
    bNew(i,:) = quatmultiply(quatmultiply(qi, [0, B]'),iqi);
    cNew(i,:) = quatmultiply(quatmultiply(qi, [0, C]'),iqi);
    dNew(i,:) = quatmultiply(quatmultiply(qi, [0, D]'),iqi);
    eNew(i,:) = quatmultiply(quatmultiply(qi, [0, E]'),iqi);
    fNew(i,:) = quatmultiply(quatmultiply(qi, [0, F]'),iqi);
    gNew(i,:) = quatmultiply(quatmultiply(qi, [0, G]'),iqi);
    hNew(i,:) = quatmultiply(quatmultiply(qi, [0, H]'),iqi);
end

t = t0:dt:tf;
figure;
plot(t, X(:,2),...
     t, X(:,3),...
     t, X(:,4), 'LineWidth', 2);
legend('X_x', 'X_y', 'X_z');
xlabel('t [s]'); 
ylabel('X');
title('Orientation of X');

figure;
plot(t, Y(:,2),...
     t, Y(:,3),...
     t, Y(:,4), 'LineWidth', 2);
legend('Y_x', 'Y_y', 'Y_z');
xlabel('t [s]'); 
ylabel('Y');
title('Orientation of Y');

%% Part (2)
S = zeros(n+1,3);
dVt = 0.5;
figure;
hold on
k = 0;
xlim([0 180]);
ylim([-40 40]);
zlim([-25 25]);
plot3(S(1,1), S(1,2), S(1,3), 'o', 'MarkerSize', 3, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'g');
for i = 1:n
    norm(X(i,2:4));
    S(i+1,:) = S(i,:) + X(i,2:4)*dVt;
    if k == 0
    P = S(i+1,:) + [aNew(i,2:4);bNew(i,2:4);fNew(i,2:4);
         hNew(i,2:4);gNew(i,2:4);cNew(i,2:4);
         aNew(i,2:4);dNew(i,2:4);eNew(i,2:4);
         hNew(i,2:4);fNew(i,2:4);dNew(i,2:4);
         eNew(i,2:4);cNew(i,2:4);gNew(i,2:4);bNew(i,2:4)];
    plot3(P(:,1),P(:,2),P(:,3));
    x = [P(1,1), P(2,1), P(5,1), P(6,1)];
    y = [P(1,2), P(2,2), P(5,2), P(6,2)];
    z = [P(1,3), P(2,3), P(5,3), P(6,3)];
    fill3(x, y, z,'y');
    pause(0.1)
    k = 10;
    end
    k = k - 1;
end
plot3(S(:,1), S(:,2), S(:,3), '-', 'LineWidth', 1, 'Color', 'r');
xlabel('x'); ylabel('y'); zlabel('z');
