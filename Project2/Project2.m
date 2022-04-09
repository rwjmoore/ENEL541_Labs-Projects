% %tf for the entire plant (including the power dynamics of the amplifier)
% b = [1200]; %numerator for continuous tf of entire plant
% a = [1 101.5 150 0]; %denominator for continuous tf of entire plant 

%tf of plant without the power dynamics of the amplifier
b = [12]; %numerator coefficients
a = [1 1.5 0];
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
Ob = obsv(A,C); %observability matrix
d = det(Ob);
%observability is very small, so we can look at the rank of the matrix and
%compare this with the A matrix to determine if it is observable 
unob = length(A)-rank(Ob);
%since unob is 0, this means it is observable. 

%check for controllability
Co = ctrb(csys); %controllability matrix
d1 = det(Co); 
%controllability has passed! 




% pole(Gz_Total);
% tester = ss(Gz_Total);


