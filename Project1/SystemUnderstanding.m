% s domain tf (without electric motor transients)
num = [12];
denom = [1 1.5 0 0]; %accomodate for 1/s input for staircase formula (added a 1/s)

Gp1 = tf(num, denom); %s domain without electric motor transients

Gp_Plant = tf([12], [1 1.5 0]);

%find the bandwidth of the system (without power amplifier) 
Gp_Plants= feedback(Gp_Plant, 1);
bandwid = bandwidth(Gp_Plants);

Gp_Total = tf([1200], [1 101.5 150 0]);
bandwid_total = bandwidth(feedback(Gp_Total, 1));

%find inverse laplace of F (symbolic math, doesnt include sampling times)
syms s t
F = Gp1;
num = poly2sym(F.Numerator, s);
den = poly2sym(F.Denominator, s);
F_t(t) = ilaplace(num/den);
G = ztrans(F_t);
[n, d ] = numden(G);
%End of symbolic math: symbolic math just for reference

%simplify the z transform function calculation
syms z 
T = 0.05; %sample rate
f (z) = 16/3*( (3/2*T-1+exp(-1.5*T))*z^2 + (1-exp(-1.5*T)-3/2*T*exp(-1.5*T)) ) / ( (z-1)*(z-exp(-1.5*T) ) );


%Z transfer function of F 
[num, denom] = numden(f);
numerator = sym2poly(num);
denominator = sym2poly(denom);
Gp_z = tf(numerator, denominator, T);

%model is the closed loop z transfer function 
model = feedback(Gp_z, 1, -1);
p = pole(model);
zer = zero(model);
p
zer
hold on;
% PlotCircle_1.m:   Plot a circle of radius 1 centered at the origin
% n: number of points

n = 50;

angle = 0:2*pi/n:2*pi;            % vector of angles at which points are drawn
R = 0.96078;                            % Unit radius

x = R*cos(angle);  y = R*sin(angle);   % Coordinates of the circle
plot(x,y);                             % Plot the circle

axis equal;
grid on;
rlocus(model);
clear angle

%Calculate the phase deficiency between our desired pole and the current
%transfer function setup. 
y = 0.1;
x = 0.75;
g = evalfr(model, 0.1+0.75i);
Ph =angle(g)*360/(2*pi);
deficiency = 180 - Ph;


%calculated zero position for controller
position = x + y/(tan(pi - deficiency*2*pi/360))


%calculate magnitude of 1/Gp_z
