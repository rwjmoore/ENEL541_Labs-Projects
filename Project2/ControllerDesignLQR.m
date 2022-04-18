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
Po = PoMag * [exp(1i*pi/4), exp(-1i*pi/4)];

L = place(A',C',Po)';

% you must set these parameters 
q1 = 10500;
q2 = 10500;
R = 40;

% call dlqr to compute the state feedback gain
Q = diag([q1 q2]);
K = dlqr(A,B,Q,R);

% Enteries for State-Feedback/Observer
Asfo = A - L*C;
Bsfo = [B-(L*D), L];
Csfo = K;
Dsfo = zeros(1,2);


%input scaling to reduce steady state error ... enter loop that determines
%best one 
N =0; 
N_count = []; 
er = [100]; 
er1 = [100];

while ((er > 0.25 | er < -0.25) |(er1 > 0.25 | er1 < -0.25)) & N < 2 
    out = sim('FinalSimModel');
    tsim = out.tout;
    [SimData, t] = SampleDataStream(out, Ts);
    
    %system inputs 
    u = SimData{4}; %how do we know what our first states are? 
    y = SimData{2};%output
    error = u-y; 
    er(end+1) = error(800); 
    er1(end+1) = error(300); 
    N_count(end+1) = N; 
    N= N + 0.01; 
    end 


