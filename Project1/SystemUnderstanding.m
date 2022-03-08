% s domain tf (without electric motor transients)
num = [12];
denom = [1 1.5 0];
Gp = tf(num, denom); %s domain without electric motor transients

%s domain with electric motor transients
num = [1200];
denom = [1 101.5 150 0];
Gtotal = tf(num, denom);


%find inverse laplace of F
syms s t
F = Gp;
num = poly2sym(F.Numerator, s);
den = poly2sym(F.Denominator, s);
F_t(t) = ilaplace(num/den);
G = ztrans(F_t);
[n, d ] = numden(G);

%Z transfer function of F
num = sym2poly(n);
denom = sym2poly(d);
F_z =filt(num, denom);

Gp_z = c2d(Gp, 0.05);
temp = filt([1 -1], [1 0], 0.05);
Gp_final = Gp_z*temp;
Gp_final = Gp_final*0.46/9187;