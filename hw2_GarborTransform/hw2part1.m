clear all; close all; clc;
load handel
v = y'/2;

L = 9;  %length of the piece
v = v(1:length(v)-1);  % periodic
n = length(v); %Fourier mode 
t = (1:length(v))/Fs;
k = (2*pi/L)*[0:n/2-1 -n/2:-1]; ks = fftshift(k);

% % original data 
% subplot(2,1,1)
% plot(t,v)
% xlabel('Time [sec]');
% ylabel('Amplitude');
% title('Signal of Interest');
% 
% % FFT
% vt=fft(v);
% subplot(2,1,2)
% plot(ks,abs(fftshift(vt))/max(abs(vt)))
% xlabel('Frequency [\omega]');
% ylabel('Amplitude');
% title('Signal in frequency domain');
% saveas(gcf,'signal.png')

% Gabor filter 
a= 0.05;
tslide = 0:0.5:9;
vgt_spec=[];
for j = 1:length(tslide)
    %g = exp(-20*(t-tslide(j)).^2);
    %g = (2/(sqrt(3*a)*pi^(1/4)))*(1-((t-tslide(j)).^2/a^2)).*exp(-(t-tslide(j)).^2/(2*a^2));
    %
    vg = g.*v;
    vgt = fft(vg);
    vgt_spec = [vgt_spec; abs(fftshift(vgt))];
    subplot(3,1,1),plot(t,v,'k',t,g,'r')
    xlabel('time (sec)'), ylabel('v(t),g(t)')
    subplot(3,1,2),plot(t,vg,'k')
    subplot(3,1,3),plot(t,abs(fftshift(vgt))/max(abs(vgt)),'k')
    axis([-50 50 0 1])
    drawnow
    pause(0.1)
end
figure()
pcolor(tslide,ks,vgt_spec.'), shading interp
xlabel('Time [sec]');
ylabel('frequency [\omega]');
colormap(hot)
drawnow, hold on
saveas(gcf,'spectrograms.png')