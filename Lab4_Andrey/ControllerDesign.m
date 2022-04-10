% controller design for pendulum experiment
% For ExB run this script first -> then the simulink -> then 

Ts = 1/200;
DampingGain = 3;             %FIX ME... Fixed April 4th by Andele
sys = CartPend(DampingGain);
% sys = InvPend(DampingGain);
sysd = c2d(sys,Ts);
A = sysd.a;
B = sysd.b;
C = sysd.c;
D = sysd.d;


% Default Observer Poles
PoMag = 0.85;
Po = PoMag * [exp(1i*pi/4) exp(-1i*pi/4) exp(1i*pi/3) exp(-1i*pi/3)];

% Po = [-0.3 -0.31 -0.32 -0.33];

L = place(A',C', Po)';




% L = place (A', C', P)'

% you must set these parameters
q1 = 10;
q2 = 10;
R = 1;  


% call dlqr to compute the state feedback gain 
Q = diag([q1 q2 0 0]);   
K = dlqr(A,B,Q,R); 

% Entreties for State-Feedbacl/Observer
Asfo = A - L*C;
Bsfo = [B-(L*D), L];
Csfo = K;
Dsfo = zeros(1,3);


