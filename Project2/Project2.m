clear
% %tf for the entire plant (including the power dynamics of the amplifier)
% b = [1200]; %numerator for continuous tf of entire plant
% a = [1 101.5 150 0]; %denominator for continuous tf of entire plant 

%tf of plant without the power dynamics of the amplifier
b = [12]; %numerator coefficients
a = [1 1.5 0 ];
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



%here we create the continuous time state space of the plant to be used in
%the simulink model 
[nums, dens] = tfdata(Gp_Total);
nums = cell2mat(nums); %convert to appropriate format (array)
dens = cell2mat(dens); 
[As, Bs, Cs, Ds] = tf2ss(nums, dens);
CtSS = ss(As, Bs, Cs, Ds); 


%this part of the script deals with the design of the discrete time
%controller for the model 

%%% OBSERVER DESIGN SECTION %%%
%Our goal is to let the observer error decay rapidly to allow quick
%tracking 
Gpoles = pole(Gz_Total); 
figure; zgrid on; plot(Gpoles, 'rx', 'markersize', 16); 

%Select pole placement of 0.85 radius for now (short transients).
PoMag = 1;
Po = PoMag * [exp(j*pi/4) exp(-j*pi/4)];

%place the new pole positions
L = place(A',C',Po)';
%notice that C is all ones and D is zero, meaning the output of observer
%tracks the states
DishObs = ss(A-L*C,[B-L*D, L],eye(2),zeros(2,2),Ts); %Observer system

%RUN Project2_Observer 
out = sim('Project2_Observer');

%test the observer 
tsim = out.tout;


[SimData, t] = SampleDataStream(out, Ts);

%system inputs 
u = SimData{3}; 
% x0 = randn(2,1);
x0 = [0 0];

%actual system results (non observer)
[y,tt,x] = lsim(CtSS,u,t,x0); %sys here is the discrete time ss of the plant
%observer results
xobs0 = zeros(2,1);
[yobs,tt,xobs] = lsim(DishObs,[u y],t,xobs0);

figure(); grid on; hold on;
subplot(121); plot(tt,yobs(:,1), tt, x(:,1)); title("Observer Out"); legend('Observer', 'Real');

subplot(122); plot(tt,yobs(:,2), tt, x(:,2)); title("Observer Out"); legend('Observer', 'Real');


