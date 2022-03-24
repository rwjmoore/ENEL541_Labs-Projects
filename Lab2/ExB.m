%before for loop

sinFreq = 1;
pendulumnData = [];
cartData = [];
    freqData = [];
pendulumn_gain = 0; 
pendulum_delay = 0; 
cart_gain = 0; 
cart_delay = 0; 
for sinfreq = 2*pi*0.32: 0.08 :2*pi*1.88
    
    %n = 1;
    %for f = 0.32:0.5:10

    out = sim('ChirpTest.slx');
    Ts = 1/200; 
    [SimData, t] =SampleDataStream(out, Ts);
    f = sinfreq/(2*pi);

    [cart_gain, cart_delay] = GainPhaseFFT(SimData{1}, SimData{2}(:,1), Ts, f, 500);
    [pendulumn_gain, pendulum_delay] = GainPhaseFFT(SimData{1}, SimData{2}(:,2), Ts, f, 500);

    pendulumnData(end+1) = pendulumn_gain; 
    cartData(end+1) = cart_gain;
    freqData(end+1) = f;



 

    %n = n+1;
    %end
end

   figure (1)
    title('Pendulumn');
    xlabel('freq');
    ylabel('dB');
    semilogx(freqData,pendulumnData,'-x');


       figure (2)
    hold on
    title('Cart');
    xlabel('freq');
    ylabel('dB');
    semilogx(freqData,cartData,'-x');

    