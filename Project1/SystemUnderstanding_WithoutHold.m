% s domain tf (without electric motor transients)
num = [12];
denom = [1 1.5 0 0]; %accomodate for 1/s input for staircase formula (added a 1/s)

Gp1 = tf(num, denom); %s domain without electric motor transients




%find inverse laplace of F (symbolic math, doesnt include sampling times)
syms s t
F = Gp1;
num = poly2sym(F.Numerator, s);
den = poly2sym(F.Denominator, s);
F_t(t) = ilaplace(num/den);
G = ztrans(F_t);
[n, d ] = numden(G);
%End of symbolic math: symbolic math just for reference

%simplify the z transform function
syms z 
T = 0.05; %sample rate
f (z) = 16/3*( (3/2*T-1+exp(-1.5*T))*z^2 + (1-exp(-1.5*T)-3/2*T*exp(-1.5*T)) ) / ( (z-1)*(z-exp(-1.5*T) ) );


%Z transfer function of F 
[num, denom] = numden(f);
numerator = sym2poly(num);
denominator = sym2poly(denom);
Gp_z = tf(numerator, denominator, T);
Gp_closedLoop = Gp_z/(1 +Gp_z);

model = feedback(Gp_z, 1, -1);
model
Gp_z
