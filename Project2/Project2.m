
b = [1200]; %numerator for continuous tf
a = [1 101.5 150 0]; %denominator for continuous tf
Ts = 0.05; % Sample Period in seconds
Gp_Total = tf(b, a); %continuous time tf
Gz_Total = c2d(Gp_Total, Ts); %Discrete time tf
[numz, denz] = tfdata(Gz_Total);
numz = cell2mat(numz); %convert to appropriate format (array)
denz = cell2mat(denz); 
[A,B,C,D] = tf2ss(numz, denz);
sys = ss(A,B,C,D); 
csys = canon(sys, 'companion'); 

%check for observability
Ob = obsv(sys); %observability matrix
d = det(Ob);
%check for controllability
Co = ctrb(csys); %controllability matrix
d1 = det(Co); 

pole(Gz_Total)

