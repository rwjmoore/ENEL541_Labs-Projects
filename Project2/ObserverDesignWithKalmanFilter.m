
%tf of plant without the power dynamics of the amplifier
b = [12]; %numerator coefficients
a = [1 1.5 0];
Ts = 0.05; % Sample Period in seconds
Gp_Total = tf(b, a); %continuous time tf
Gz_Total = c2d(Gp_Total, Ts); %Discrete time tf
[nums, dens] = tfdata(Gp_Total);
nums = cell2mat(nums); %convert to appropriate format (array)
dens = cell2mat(dens); 
[A,B,C,D] = tf2ss(nums, dens);
sys = ss(A,B,C,D); %continuous state space model of the satellite dish
As= sys.A; 
Bs = sys.B; 
Cs = sys.C; 
Ds = sys.D;

sys = c2d(sys, Ts);% discrete state space model of satellite dish
A = sys.A;
B = sys.B; 
C = sys.C;
D = sys.D;



%Kalman Filter Design
noisy = wgn(201,1,20);
covari = cov(noisy); 


Q = [1 0; 0 1]; % Process noise covariance 
R = [1000]; %Sensor noise covariance
%Create a modiifed sys 
G = eye(2); 
H = [0,0];
kalm_sys = ss(A, [B, G], C, [D, H], Ts);
 
[kalmf, L, ~, Mx, Z] = kalman(kalm_sys, Q,R); 
% kalmf = kalmf(2,:); 
 

%test the ability of system to detect output even with noise 
tsim = out.tout;
[SimData, t] = SampleDataStream(out, Ts);

%system inputs 
u = SimData{3}; %how do we know what our first states are? 
x0 = randn(2,1); 
%x0 = [1000000 1];

%RUN Project2_Observer_KalmanFilter to obtain outputs of CT state space 
out = sim('Project2_Observer_KalmanFilter.slx');

%actual system results (non observer)
[y,tt,x] = lsim(sys,u,t,x0); %sys here is the discrete time ss of the plant

%adding in noise to the vector y to simulate encoder noise 
noisy_y = noisy + y;

%Kalman filter results
xobs0 = zeros(2,1);
[yobs,tt,xobs] = lsim(kalmf,[u noisy_y], t);


figure();
subplot(131); plot(tt,yobs(:,3), tt, x(:,2)); title("State of System vs Observer Output: State 2"); legend('Observer', 'Real');
subplot(132); plot(tt,yobs(:,2), tt, x(:,1)); title("State of System vs Observer Output: State 1"); legend('Observer', 'Real');
subplot(133); plot(tt,yobs(:,1), tt, noisy_y, tt, y); title("Output Compared with Estimated Output"); legend('Observer Output', 'Noisy Output', 'Real Output');



%ANDREY ------ Use kalmf.A, kalmf.B, etc for the "Observer Matrices" in the
%LQR design code. Note that this state space has 3 outputs, so you might
%have to some tweaking to the output of the simulink model. Not entirely
%sure how this translates to the L matrix since the "poles" of this
%observer are already optimally placed. 
