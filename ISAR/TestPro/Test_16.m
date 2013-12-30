function Test_16
%TEST_16 Summary of this function goes here
%   Detailed explanation goes here
close all;
clear all;
clc;

Nd = 0.85;
a = zeros(1,10000);
temp_a = zeros(1,1000);
temp_a(1:2:end) = 1;
a(4501:5500) = temp_a;
figure,plot(a);
fft_a = fftshift(fft(a));
figure,plot(real(fft_a));
fft_a = fft_a.*exp((-1)*1i*Nd*2*pi*(-4999:5000)/10000);
figure,plot(real(fft_a));
a = ifft(fft_a);
figure,plot(abs(a));
end

