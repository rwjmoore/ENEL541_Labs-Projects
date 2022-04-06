tsim = out.tout;

Ts = 1/200; 
[SimData, t] =SampleDataStream(out, Ts);


%state space model
Gs = CartPend(0.5);
Gz = c2d(Gs, 1/200); 
u = SimData{1};
y1 = lsim(Gs, u, t);

figure(1);
subplot(121);plot(t, y1(:, 1), t, SimData{2,1}(:, 1));
legend("Cart Position - Linear","Cart Position -Sim" );
title("Cart Position")
subplot(122); plot(t, y1(:, 2), t, SimData{2, 1}(:, 2));
legend("Pendulumn Angle -Linear",  "Pendulumn Angle  - Sim");
title("Pendulum angle");



%plot showing cart position and pendulum angle (note that x0 in
%NLpendulum.m was modified to be pi-0.01

% %state space model
% Gs = CartPend(3);
% Gz = c2d(Gs, 1/200); 
% u = SimData{1};
% y1 = lsim(Gs, u, t);
% figure;
% plot(t, y1(:, 1));
% hold on; 
% plot(t, y1(:, 2)); 
% legend("Cart position", "pendulum angle");
% title("Cart pendulum response with initial condition to pi-0.01");
plot(t, SimData{2,1}(:, 1)); 
hold on; 
plot(t, SimData{2,1}(:, 2))
legend('cart position', 'pendulum angle')