tsim = out.tout;

Ts = 1/200; 
[SimData, t] =SampleDataStream(out, Ts);

Gs = CartPend(2);
Gz = c2d(Gs, 1/200); 
u = SimData{1};
y1 = lsim(Gs, u, t);

GPoles = pole(Gz);
% figure; 
% zgrid on
% plot(GPoles, 'rx', 'markersize',16);
PoMag = 0.85; 

Po = PoMag * [exp(j*pi/4) exp(-j*pi/4) exp(j*pi/3) exp(-j*pi/3)];
A = Gz.a;
B = Gz.b;
C = Gz.c;
D = Gz.d

L = place(A', C', Po)';

PendObs = ss(A-L*C,[B-L*D, L],eye(4),zeros(4,3),Ts);

%test the observer by starting model in random place
x0 = randn(4,1);
%simulate response to chirp input 
[y,tt,x] = lsim(Gz,u,t,x0);

%now use observer to estimate the states given only input and ouput. 
xobs0 = zeros(4,1)
[yobs,tt,xobs] = lsim(PendObs,[u y],t,xobs0);
%plotting 4 outputs of the observer, superimposed on the 4 states of the
%simualted model 
figure('NumberTitle', 'off', 'Name', 'Original Model');
subplot(141); plot(tt, x(:,1), tt, yobs(:,1)); title("State 1"); legend('state 1', 'observer out 1');
subplot(142); plot(tt, x(:,2), tt, yobs(:,2)); title("State 2"); legend('state 2', 'observer out 2');
subplot(143); plot(tt, x(:,3), tt, yobs(:,3)); title("State 3"); legend('state 3', 'observer out 3');
subplot(144); plot(tt, x(:,4), tt, yobs(:,4)); title("State 4"); legend('state 4', 'observer out 4');




%Generating a second observer with different poles 

%let us try to reduce the magnitude of the poles. 



PoMag = 0.85; 

Po = PoMag * [exp(j*pi/4) exp(-j*pi/4) exp(j*pi/3) exp(-j*pi/3)];
A = Gz.a;
B = Gz.b;
C = Gz.c;
D = Gz.d

L = place(A', C', Po)';

PendObs = ss(A-L*C,[B-L*D, L],eye(4),zeros(4,3),Ts);

%test the observer by starting model in random place
x0 = randn(4,1);
%simulate response to chirp input 
[y,tt,x] = lsim(Gz,u,t,x0);

%now use observer to estimate the states given only input and ouput. 
xobs0 = zeros(4,1)
[yobs2,tt,xobs] = lsim(PendObs,[u y],t,xobs0);
%plotting 4 outputs of the observer, superimposed on the 4 states of the
%simualted model 
figure('NumberTitle', 'off', 'Name', 'Modified Gain =');
subplot(141); plot(tt, yobs(:,1), tt, yobs2(:,1)); title("State 1"); legend('Original', 'Decreased Gain');
subplot(142); plot(tt, yobs(:,2), tt, yobs2(:,2)); title("State 2"); legend('Original', 'Decreased Gain');
subplot(143); plot(tt, yobs(:,3), tt, yobs2(:,3)); title("State 3"); legend('Original', 'Decreased Gain');
subplot(144); plot(tt, yobs(:,4), tt, yobs2(:,4)); title("State 4"); legend('Original', 'Decreased Gain');


