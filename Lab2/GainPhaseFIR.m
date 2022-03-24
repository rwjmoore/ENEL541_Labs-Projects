function [gain,phase] = GainPhaseFIR(u,y,T,freq,ntrans)
%  [gain,phase] = GainPhaseFIR(u,y,T,freq,ntrans)
%
%  estimates the gain and phase of the transfer function between input u and
%  output y, using a two-tap fir filter.  The input, u, is assumed to
%  contain a single sinusoidal component.
%
%  T is the sample period
%  freq is the frequency of the input sinusoid
%  ntrans is the length of the segment at the beginning that is ignored
%         (beacuse it is assumed to be dominated by the transient response).

% dtw 09 2008

u = u(:);
y = y(:);

N = length(u);
w = 2*pi*freq;   % radian frequency



U = zeros(N,2);  % matrix for linear regression
U(:,1) = u;
U(:,2) = [0; u(1:N-1)];

h = U(ntrans+1:N,:)\y(ntrans+1:N);   %ignore the first ntrans points.

testout = U*h;
figure
subplot(211)
plot([y testout]);
hold on
plot([ntrans+1 ntrans+1],[y(ntrans+1) testout(ntrans+1)],'k-*');
hold off
legend('y','FIR fit','ntrans');
title('measured output and two tap FIR output');

subplot(212)
err = y - testout;
plot(err);
hold on
plot(err(1:ntrans),'r');
hold off
xlabel('Time (samples)');
ylabel('error');



fir = tf(h',1,T,'variable','z^-1');
Gw = freqresp(fir,w);
gain = 20*log10(abs(Gw));
phase = angle(Gw)*180/pi;

