% ENEL 541 
% Lab 4

Ts = 1/200;
[SimData, t] = SampleDataStream(out, Ts);

% figure;
% hold on;
% plot(t, SimData{1});
% plot(t, SimData{2,1}(:,1));
% plot(t, SimData{2,1}(:,2));
% legend("Chirp Input", "Cart Position", "Pendulumn Angle");
% xlabel("seconds");
% title("System I/O ")

% linear state-space models
Gs = CartPend(2);
Gz = c2d(Gs,Ts);
u = SimData{1};
y1 = lsim(Gs, u, t);

figure;
subplot(2,1,2);
hold on
plot(t,y1(:,1)); % Cart Position - Linear
plot(t, SimData{2,1}(:, 1)); % Cart Position - Sim
legend("Cart Positoin - Linear", "Cart Position - Sim");
hold off

subplot(2,1,1);
hold on
plot(t, y1(:,2)); % Pendulumn Angle - Linear
plot(t, SimData{2,1}(:,2)); % Pendulumn Angle - Sim
legend("Pendulumn Angle - Linear", "Pendulumn Angle - Sim");
hold off



