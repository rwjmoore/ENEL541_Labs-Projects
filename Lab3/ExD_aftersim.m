tsim = out.tout;

Ts = 1/200; 
[SimData, t] =SampleDataStream(out, Ts);

cart_position = SimData{1}(:,1);
pendulum_angle = SimData{1}(:,2);
control_input = SimData{2};

figure; 
plot(t, cart_position, t, pendulum_angle, t, control_input); 
legend("cart_position", "pendulum angle", "control input"); 

