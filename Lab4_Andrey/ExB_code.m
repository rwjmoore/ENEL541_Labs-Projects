% ENEL 541 
% Lab 4

% Steps to making the last part of ExB work
% (1) change q1 and q2 in ControllerDesign 
% (2) run the ControllerDesign Script
% (3) run the simulink Script
% (4) then run this script (which will extract stepinfo information using
% stepinfo(...) fomr the simulink simulation

Ts = 1/200;
[SimData, t] = SampleDataStream(out, Ts);
figure;
plot(t, SimData{1}); % Shows both outputs
figure;
plot(t, SimData{1,1}(:,1)); title("Cart Position"); % cart position
figure;grid on
plot(t, SimData{1,1}(:,2)); title("Pendulumn Angle"); % pendulumn angle

% Stepinfo of cart position
CartInfo = stepinfo(SimData{1,1}(:,1),t);
%Stepinfo of pendulumn angle
PendulumnInfo = stepinfo(SimData{1,1}(:,2),t);







