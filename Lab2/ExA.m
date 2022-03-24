% t = out.tout;
% dt = t(2:end) - t(1:end-1);
%  plot(t(1:end-1), dt, '+');
% xlabel('Time (seconds)');
% ylabel('Intersample Interval (seconds)')


%exercise B
Ts = 1/200; 
[SimData, t] =SampleDataStream(out, Ts);

figure; 
hold on; 
plot(t, SimData{1}); 
plot(t, SimData{2,1}(:, 1));
plot(t, SimData{2, 1}(:, 2));
legend("Sine Input", "Cart Position", "Pendulumn Angle");
xlabel("seconds");
title("System I/O ")


%computing gains and delays
f = 1; %Hz
%91.8 degrees for pendulumn angle
[cart_gain cart_delay] = GainPhaseFFT(SimData{1}, SimData{2}(:,1), Ts, f, 500);
[pendulumn_gain pendulum_delay] = GainPhaseFFT(SimData{1}, SimData{2}(:,2), Ts, f, 500);
timeD_cart = cart_delay/360*1/f;
timeD_pendulum = pendulum_delay/360*1/f;

%calculating frequency
x = 28; %seconds
freq = 0.2+x/30*1.8;
