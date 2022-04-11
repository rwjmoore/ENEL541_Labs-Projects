% Project 4
% LQR Controller of the antenna system

%Note: Run this script first -> then the simulation

Ts = 0.05;
DampingGain = 3;             %Fixed April 4th by Andrey

% model of the system continous state space modle
% sys
%
%-------------------------------------------------------------------------
%
%tf of plant without the power dynamics of the amplifier
% TODO: Ask Randy for updated plant system model 
%tf of plant without the power dynamics of the amplifier
b = [12]; %numerator coefficients
a = [1 1.5 0];
Ts = 0.05; % Sample Period in seconds
Gp_Total = tf(b, a); %continuous time tf
Gz_Total = c2d(Gp_Total, Ts); %Discrete time tf
[nums, dens] = tfdata(Gp_Total);
nums = cell2mat(nums); %convert to appropriate format (array)
dens = cell2mat(dens); 
[A,B,C,D] = tf2ss(nums, dens);
sys = ss(A,B,C,D); %continuous state space model of the satellite dish

sys = c2d(sys, Ts);% discrete state space model of satellite dish
A = sys.A;
B = sys.B; 
C = sys.C;
D = sys.D;
%
%-------------------------------------------------------------------------
% end sys


% Default Observer Poles
PoMag = 0.3;
% TODO: get a better Observer Pole
Po = PoMag * [exp(1i*pi/4), exp(-1i*pi/4)];

L = place(A',C',Po)';

% you must set these parameters 
q1 = 10;
q2 = 10;
R = 1;

% call dlqr to compute the state feedback gain
Q = diag([q1 q2]);
K = dlqr(A,B,Q,R);

% Enteries for State-Feedback/Observer
Asfo = A - L*C;
Bsfo = [B-(L*D), L];
Csfo = K;
Dsfo = zeros(1,2);


out = sim('FinalSimModel');


