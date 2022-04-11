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
b = [12]; %numerator coefficients
a = [1 1.5 0];
Ts = 0.05; % Sample Period in seconds
Gp_Total = tf(b, a); %continuous time tf
Gz_Total = c2d(Gp_Total, Ts); %Discrete time tf
[numz, denz] = tfdata(Gz_Total);
numz = cell2mat(numz); %convert to appropriate format (array)
denz = cell2mat(denz); 
[A,B,C,D] = tf2ss(numz, denz);
sys = ss(A,B,C,D); 
%
%-------------------------------------------------------------------------
% end sys

sysd = c2d(sys,Ts);
A = sysd.a;
B = sysd.b;
C = sysd.c;
D = sysd.d;


% Default Observer Poles
PoMag = 0.85;
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


