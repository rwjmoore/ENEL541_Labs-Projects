function Gs = PitchPlunge;
% generates the linear part of the pitch-plunge model used in ICNPAA paper.
% >>   Gs = PitchPlunge;



% Physical constants
U = 18; % m/s
a = -0.6; % m 
b = 0.135; % m
Ia = 0.065; % m^2 Kg
Kh = 2844;  % N/m
Ka = 2.82;  % Nm/rad
Xa = 0.247; % m 
Ch = 27.4;  % Kg/s 
Ca = 0.180; % m2 Kg/s 
rho = 1.23;  % Kg/m^3
Cla = 3.28;
Clb = 3.36;
Cma = -0.628;
Cmb = -0.635;
k = 2;
m = 8.7; %Kg

% Intermediate Matrices
M = [m m*Xa*b; m*Xa*b Ia];
C = [(Ch + rho*U*b*Cla) rho*U*b^2*Cla*(0.5-a);
     -rho*U*b^2*Cma  (Ca-rho*U*b^3*Cma*(0.5-a))];
K = [Kh rho*U^2*b*Cla; 0 -rho*U^2*b^2*Cma+Ka];
F = [-U^2*rho*b*Clb; U^2*rho*b^2*Cmb];

% System Matrices

sysA = [zeros(2,2) eye(2);-inv(M)*[K C]];
sysB = [0;0;-inv(M)*F];
sysC = [1 0 0 0];
sysD = 0;

Gs = ss(sysA,sysB,sysC,sysD);


