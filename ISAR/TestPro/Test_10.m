function Test_10
%TEST_10 Summary of this function goes here
%   Detailed explanation goes here
close all
a1 =zeros(1,2000);
a2 =zeros(1,2000);
a3 =zeros(1,2000);
a1(1:201) = ones(1,201);
a2(900:1100) = ones(1,201);
a3(1:100) = ones(1,100);
a3(1900:2000) = ones(1,101);


fft_a1 = fftshift(ifft(a1));
fft_a2 = fftshift(ifft(a2));
fft_a3 = fftshift(ifft(a3));
subplot(3,2,1),plot(real(a1))
subplot(3,2,3),plot(real(a2))
subplot(3,2,5),plot(real(a3))
subplot(3,2,2),plot(real(fft_a1))
subplot(3,2,4),plot(real(fft_a2))
subplot(3,2,6),plot(real(fft_a3))
end

