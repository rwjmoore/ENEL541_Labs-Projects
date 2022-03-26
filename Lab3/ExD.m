
%Use state feedback to slightly modify the systems poles 
%plotting the original poles
figure; 
zgrid on
plot(GPoles, 'rx', 'markersize',16);
%modifying pole position
%calculating 2%settling time
Pmags = abs(GPoles)
T2s = 4*Ts./abs(log(Pmags))
Zmag = exp(-4*Ts); %new radius that the poles must be within for 5 second settling time

%replace the integrator with a pole at z = Zmag
%leave complex pole freqeuncy of oscillation alone since this is likely
%close to natural frequency of the pendulum 
Zangle = angle(GPoles(2))
%now change the pole locations but keep frequency the same. 
Pc = [ Zmag, Zmag*exp(j*Zangle), Zmag*exp(-j*Zangle), min(GPoles) ];

%checking that new pole location is correct
hold on
plot(Pc, 'mx','markersize',14)

K = place(A, B, Pc);


