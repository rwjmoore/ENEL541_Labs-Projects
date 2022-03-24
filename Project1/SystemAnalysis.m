%1 = output of system 
%2 = error of system

Ts = 1/20;
[SimData, t] = SampleDataStream(out,Ts);

stepinfo(SimData{1}, t,'SettlingTimeThreshold',0.02) %0.025 because of
SettleThreshold = 0.25; %degrees
i = length(t);
while(true)
   if not(SimData{1}(i) > (58-0.25 ) && SimData{1}(i)<(58+0.25))
       settlingIndex = i;
       break;
   end
   i = i -1;
end
Settling = t(settlingIndex) -1;
plot(t, SimData{1}); hold on; 
yline(12.5-0.25); yline(12.5+0.25);