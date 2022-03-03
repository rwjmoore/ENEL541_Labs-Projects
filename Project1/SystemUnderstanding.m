% s domain tf 
num = [12];
denom = [1 1.5 1 0];

%note that we divide our system by s in order to emulate the ramp input
%with a step response 
Gp = tf(num, denom);

