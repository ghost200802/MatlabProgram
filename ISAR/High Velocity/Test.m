function Test
%TEST Summary of this function goes here
%   Detailed explanation goes here
clc;
close all;
clear all;

i = 0:0.0005:1;
F0 = 1000;
K = 1000;

a = zeros(1,10000);
b = zeros(1,10000);

a(1:length(i)) = exp(1i*(2*pi*F0*i+K*pi*i.^2));
figure,plot(real(a));
b(1001:length(i)+1000) = exp(1i*(2*pi*F0*i+K*pi*i.^2));
figure,plot(real(b));

fft_a = fft(a);
fft_b = conj(fft(b));

fft_c = fft_a.*fft_b;

c = ifft(fft_c);
figure,plot(abs(c)/max(abs(c)));
figure,plot(10*log2(abs(c)/max(abs(c))));

end

