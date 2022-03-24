function [gain,phase] = GainPhaseFFT(u,y,T,freq,ntrans)
%  [gain,phase] = GainPhaseFFT(u,y,T,freq,ntrans)
%
%  estimates the gain and phase of the transfer function between input u and
%  output y, using FFTs of the two signals.  The input, u, is assumed to
%  contain a single sinusoidal component.
%
%  T is the sample period
%  freq is the frequency of the input sinusoid
%  ntrans is the length of the segment at the beginning that is ignored
%         (beacuse it is assumed to be dominated by the transient response).

% dtw 02 2018

u = u(:);
y = y(:);

N = length(u);
w = 2*pi*freq;   % radian frequency

M = 1/(freq*T);  % input period in samples
stop = ntrans+floor((N-ntrans)/M)*M;
uclean = u(ntrans+1:stop);  % extract complete periods after transients
yclean = y(ntrans+1:stop);
U = fft(uclean); % compute FFTs
Y = fft(yclean);

halflen = floor(length(U)/2);
[Upeak,pos] = max(U(1:halflen));
Ypeak = Y(pos);

% figure
% subplot(211)
% semilogy(abs(U));
% ylabel('Magnitude of Input FFT')
% subplot(212)
% semilogy(abs(Y));
% ylabel('Magnitude of Output FFT')
% xlabel('Frequency Bin');



gain = 20*log10(abs(Ypeak)/abs(Upeak));
phase = (angle(Ypeak)-angle(Upeak))*180/pi;




