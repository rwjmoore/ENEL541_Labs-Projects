% controller design for pendulum experiment


Ts = 1/200;
DampingGain = 1;             %FIX ME
sys = CartPend(DampingGain);
%sys = InvPend(DampingGain);
sysd = c2d(sys,Ts);
A = sysd.a;
B = sysd.b;
C = sysd.c;
D = sysd.d;


% Default Observer Poles
PoMag = 0.85;
Po = PoMag * [exp(j*pi/4) exp(-j*pi/4) exp(j*pi/3) exp(-j*pi/3)];

%Po = [-0.3 -0.31 -0.32 -0.33];

L = place(A',C', Po)';




%L = place (A', C', P)'

% you must set these parameters
q1 = 1;
q2 = 1;
R = 100;  


% call dlqr to compute the state feedback gain 
Q = diag([q1 q2 0 0]);   
K = dlqr(A,B,Q,R); 

