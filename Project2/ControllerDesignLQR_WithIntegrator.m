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
a = [1 1.5 0 0];
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

%here we create the continuous time state space of the plant to be used in
%the simulink model 
[nums, dens] = tfdata(Gp_Total);
nums = cell2mat(nums); %convert to appropriate format (array)
dens = cell2mat(dens); 
[As, Bs, Cs, Ds] = tf2ss(nums, dens);


%
%-------------------------------------------------------------------------
% end sys


% Default Observer Poles
PoMag = 0.01;
% TODO: get a better Observer Pole
Po = PoMag * [exp(1i*pi/4), exp(-1i*pi/4) 1];

L = place(A',C',Po)';

% you must set these parameters 
val = 10500;
q1 = val;
q2 = val;
q3 = val;
R = 0.5;

% call dlqr to compute the state feedback gain
Q = diag([q1 q2 q3]);
K = dlqr(A,B,Q,R);

% Enteries for State-Feedback/Observer
Asfo = A - L*C;
Bsfo = [B-(L*D), L];
Csfo = K;
Dsfo = zeros(1,2);


%input scaling to reduce steady state error 
N = -(C*(A-B*K)^-1*B)^-1;
N = 1/N(1);
N = 12.5/13.14;
N = 1;
out = sim('FinalSimModel_Integrator');


