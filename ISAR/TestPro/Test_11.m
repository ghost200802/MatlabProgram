function Test_11
%TEST_11 Summary of this function goes here
%   Detailed explanation goes here
close all
clear all
i = 1:1000;
f = 0.005
k = 0.0001
a = exp(1i*2*pi*f*i+1i*pi*k*i.^2);
figure,plot(real(a));
fft_a = fftshift(fft(a));
figure,plot(abs(fft_a));
figure,plot(angle(fft_a));

i = -10:0.1:10;
b = sinc(i);
figure,plot(b);
fft_b = fftshift(fft(b));
figure,plot(abs(fft_b));
figure,plot(angle(fft_b));

end

