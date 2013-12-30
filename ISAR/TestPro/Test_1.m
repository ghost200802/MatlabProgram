function Test
%TEST Summary of this function goes here
%   Detailed explanation goes here
close all
clear all

t = 1:1000;
t = t/1000;
A = zeros(1,2000);
B = zeros(1,2000);
A(1:1000) = exp(1i*2*pi*t+1i*2*pi*(2*t).^2);
B(501:1500) = B(501:1500)+exp(1i*2*pi*t+1i*2*pi*(2*t).^2);
B(801:1800) = exp(1i*2*pi*t+1i*2*pi*t.^2);


fft_A = fftshift(fft(A));
fft_B = fftshift(fft(B));

C = ifftshift(ifft(fft_A.*fft_B));
figure
plot(abs(C));

end

