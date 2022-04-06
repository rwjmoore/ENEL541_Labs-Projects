function [sys,x0,str,ts] = NLpendulum(t,x,u,flag)
% SFunction for the cart pendulum system with nonlinear pendulum
% dynamics.

% DTW  04/2020


switch flag,

  %%%%%%%%%%%%%%%%%%
  % Initialization %
  %%%%%%%%%%%%%%%%%%
  case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;

  %%%%%%%%%%%%%%%
  % Derivatives %
  %%%%%%%%%%%%%%%
  case 1,
    sys=mdlDerivatives(x,u);

  %%%%%%%%%%%
  % Outputs %
  %%%%%%%%%%%
  case 3,
    sys=mdlOutputs(x);

  %%%%%%%%%%%%%%%%%%%
  % Unhandled flags %
  %%%%%%%%%%%%%%%%%%%
  case { 2, 4, 9 },
    sys = [];

  %%%%%%%%%%%%%%%%%%%%
  % Unexpected flags %
  %%%%%%%%%%%%%%%%%%%%
  otherwise
    DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));

end
% end csfunc

%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts]=mdlInitializeSizes




sizes = simsizes;
sizes.NumContStates  = 4;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 2;
sizes.NumInputs      = 1;   
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;

sys = simsizes(sizes);
x0  = zeros(4,1);
x0(2) = pi - 0.01;
str = [];
ts  = [0 0];

% end mdlInitializeSizes
%
%=============================================================================
% mdlDerivatives
% Return the derivatives for the continuous states.
%=============================================================================
%
function sys=mdlDerivatives(x,u)

M = 0.8;      % Kg - mass of cart
m = 0.2;      % Kg - mass of pendulum
l = 0.275;    % m -- length from pivot to centre of mass
L = 0.6;      % m -- length of pendulum.
R = 10;       % ohms -- armature resistance
Km = 0.01474; % N-m/Amp  Motor torque constant
Kg = 3.7;     % gear ratio.
r = 0.00625;  % m pinion radius.

g = -9.81;     % m/s^2 gravity constant (-ve to un-invert pendulum)
I = (1/12)*m*L^2;        % inertia of pendulum     
PWMgain = 13;           %  PWM maps +/- 1 to +/0 13 V
DampingGain = 3;       % Damping Gain -- 

% set up the continuous-time state-space equations for the state
% vector [x theta xdot thetadot]'; 

% The damping is primarily due to the back EMF of the motor.
b = DampingGain*(Km*Kg)^2/(R*r^2);

%  The force input is due to the motor torque. 
Kf = PWMgain*Kg*Km/(R*r);

% Bouc-Wen friction parameters
% Reference J.P Noel and Maarten Schoukens, 
% Hysteretic benchmark with a dynamic nonlinearity
% Workshop on Nonlinear System Identification Benchmarks
% April 25-27, 2016, Brussels, Belgium

% Default parameters from Noel and Schoukens:
% alpha = 5e4; 
alpha = 100;
%beta = 1e3; 
beta = 40;
gamma = 0.8;
%delta = -1.1;
delta = -0.4;
nu = 1;

% saturate input at plus/minus 1 (i.e. 100% duty cycle on PWM)
% if u > 1
%     u = 1;
% elseif u < -1
%     u = -1;
% end


xdot = zeros(4,1);
xdot(1:2) = x(3:4);
ydot = x(3);



theta = x(2); ct = cos(theta); st = sin(theta); 
Xmat = [(M+m) m*l*ct; m*l*ct I+m*l^2*ct^2];

w1 = Kf*u(1) - b*x(3) + m*l*st*x(4)^2 ;  % got rid of -z here
w2 = m*l*st*(g + l*ct*x(4)^2 - l*(x(4)*st-x(4)^2*ct));
xddot = Xmat\[w1; w2];
xdot(3:4) = xddot;

sys = xdot;



% end mdlDerivatives
%
%=============================================================================
% mdlOutputs
% Return the block outputs.
%=============================================================================
%
function sys=mdlOutputs(x)


sys =x(1:2);

% end mdlOutputs
