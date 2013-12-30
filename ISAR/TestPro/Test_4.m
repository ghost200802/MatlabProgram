function  Test_4
%TEST_4 Summary of this function goes here
%   Detailed explanation goes here
k = 1:10000;
k(1:1000) = zeros(1,1000);
k(2001:10000) = zeros(1,8000);
a = exp(1i*0.02*k);
fft_a = fftshift(fft(a));
figure,plot(real(fft_a));


end

