tsim = out.tout;

Ts = 1/200; 
[SimData, t] =SampleDataStream(out, Ts);

% figure; 
% hold on; 
% plot(t, SimData{1}); 
% plot(t, SimData{2,1}(:, 1));
% plot(t, SimData{2, 1}(:, 2));
% legend("Chirp Input", "Cart Position", "Pendulumn Angle");
% xlabel("seconds");
% title("System I/O ")

%approximating the system using a linear state-space model 
Gs = CartPend(2);
Gz = c2d(Gs, 1/200); 
u = SimData{1};
y1 = lsim(Gs, u, t);
figure;
plot(t, y1(:, 1));
hold on
plot(t, y1(:, 2));
plot(t, SimData{2,1}(:, 1));
plot(t, SimData{2, 1}(:, 2));
legend("Cart Position - Linear", "Pendulumn Angle -Linear", "Cart Position -Sim", "Pendulumn Angle  - Sim");
title("Comparison of Linear and Appartus Outputs")
