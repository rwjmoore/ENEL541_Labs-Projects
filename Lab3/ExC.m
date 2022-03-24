% extracting the data from the simulation of the state observer 
tsim = out.tout;

Ts = 1/200; 
[SimData, t] =SampleDataStream(out, Ts);
%Observer Output is 4 columns 
cart_position = SimData{1,1}(:, 1);
pendulumn_angle = SimData{1,1}(:,2); 

%observer estimates 
cart_positionobs = SimData{3,1}(:,1);
pendulumn_angleobs = SimData{3,1}(:,2);

%superimpose the estimates and the encoder outputs
% figure; 
% subplot(121); plot(t, cart_position, t, cart_positionobs);title('cart position'); legend('encoder measurement', 'observer estimate');
% subplot(122); plot(t, pendulumn_angle, t, pendulumn_angleobs);title('pendulumn angle'); legend('encoder measurement', 'observer estimate');


%integrating the angular and linear velocities
linear_veloc = SimData{3,1}(:,3);
angular_veloc = SimData{3,1}(:,4);
l1 = cumsum(linear_veloc)*Ts;
l2 = cumsum(angular_veloc)*Ts;

figure; 
subplot(121); plot(t, cart_position, t, l1);title('cart position'); legend('encoder measurement', 'observer estimate');
subplot(122); plot(t, pendulumn_angle, t, l2);title('pendulumn angle'); legend('encoder measurement', 'observer estimate');

%using the function smoothddt to compare states 3 and 4 with the derivative
%of the actual simulated values 

ddtCart = smoothddt(cart_position, Ts);
ddtPend = smoothddt(pendulumn_angle, Ts); 
figure; 
subplot(121); plot(t, ddtCart, t, linear_veloc);title('cart position'); legend('encoder measurement derivative', 'observer estimate');
subplot(122); plot(t, ddtPend, t, angular_veloc);title('pendulumn angle'); legend('encoder measurement derivatives', 'observer estimate');

%finally, adding noise to measurements and then taking the derivative
N = length(cart_position); 
noise = randn(N,1);
noise = noise *std(cart_position)/100;
cart_noisy = noise + cart_position;

noise = randn(N,1);
noise = noise *std(pendulumn_angle)/100;
pend_noisy = noise + pendulumn_angle;

ddtCart_noise = smoothddt(cart_noisy, Ts);
ddtPend_noise = smoothddt(pend_noisy, Ts); 

figure; 
subplot(121); plot(t, ddtCart_noise, t, linear_veloc);title('cart position'); legend('encoder measurement derivative w/noise', 'observer estimate');
subplot(122); plot(t, ddtPend_noise, t, angular_veloc);title('pendulumn angle'); legend('encoder measurement derivative w/noise', 'observer estimate');


