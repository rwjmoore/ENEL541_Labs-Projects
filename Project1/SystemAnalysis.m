%1 = output of system 
%2 = error of system

Ts = 1/20;
[SimData, t] = SampleDataStream(out,Ts);

stepinfo(SimData{1}, t,'SettlingTimeThreshold',0.025) %0.025 because of 