function sys = InvPend(DampingGain);
% generates a continuous-time state-space model of a cart and pendulum
% system 
%
%  syntax: sys = CartPend;
%
%  DTW 03/2001


% Physical Constants.

M = 0.8;      % Kg - mass of cart
m = 0.2;      % Kg - mass of pendulum
l = 0.275;    % m -- length from pivot to centre of mass
L = 0.6;      % m -- length of pendulum.
R = 10;       % ohms -- armature resistance
Km = 0.01474; % N-m/Amp  Motor torque constant
Kg = 3.7;     % gear ratio.
r = 0.00625;  % m pinion radius.


g = 9.81;     % m/s^2 gravity constant
I = (1/12)*m*L^2;        % inertia of pendulum     
PWMgain = 6.5;           % Original amplifier had non-inverting
                         % gain of 2. PWM maps +/- 1 to +/0 13 V
                         %


% set up the continuous-time state-space equations for the state
% vector [x theta xdot thetadot]'; 


% den is the common factor in the denominator of all non-zero 
% matrix entries in the model.
den = I*(M+m) + M*m*l^2;

% The damping is primarily due to the back EMF of the motor.
b = DampingGain*(Km*Kg)^2/(R*r^2);

%  The force input is due to the motor torque. 
Kf = 2* Kg*Km/(R*r);


% Now, set up the state-space matrices.

% from theta to xddot
a1 = (m^2 * g * l^2)/den; 
% from xdot to xddot
a2 = (I+m*l^2)*b/den;
% from theta t0 thetaddot
a3 = m*g*l*(M+m)/den;
% from xdot to thetaddot
a4 = m*l*b/den;


A = [0 0  1  0;
     0 0  0  1;
     0 a1  -a2 0;
     0 a3  -a4 0];


% from u to xddot
b1 = Kf*(I + m*l^2)/den;
% from u to thetaddot
b2 = Kf*m*l/den;

B = PWMgain*[0;0;b1;b2];

C = [1 0 0 0;0 1 0 0];
D = [0;0];

sys = ss(A,B,C,D);





