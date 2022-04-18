tsim = out.tout;
[SimData, t] = SampleDataStream(out, Ts);

%system inputs 
u = SimData{4}; %how do we know what our first states are? 
y = SimData{2};%output
error = u-y; 
figure; 
grid on;
subplot(121); plot(t, u);hold on; plot(t, y); xlabel("seconds"); title("Plots of Ramp Input and System Output"); legend('input', 'output');
subplot(122); grid on; plot(t, u-y); title("Error"); xlabel("seconds"); 

slope = (error(800) - error(799))/(t(800)-t(799))
hold on; xline(t(800))