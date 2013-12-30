function  Test_3
%TEST_3 Summary of this function goes here
%   Detailed explanation goes here
%本测试说明了频域补零时域插值只对单边信号（例如复指数信号）有用，对双边信号（如正弦信号）结果错误
clear all;
close all;

Max = 20;

a = 1:Max;
a = exp(1i*0.23*pi*a);
figure
subplot(2,2,1),plot(real(a));
title('原始信号');

K = 10;

fft_a = fft(a);
fft_a1 = zeros(1,Max*K);
fft_a2 = zeros(1,Max*K);

fft_a1(1:Max) = fft_a;

subplot(2,2,2),plot(abs(fft_a))
title('信号频谱');

fft_a2(1:K:Max*K-K+1) = fft_a;


b1 = ifft(fft_a1);
b2 = ifft(fft_a2);

fft_a1 = fftshift(fft_a1);
fft_a2 = fftshift(fft_a2);

b3 = ifftshift(ifft(fft_a1));
b4 = ifftshift(ifft(fft_a2));


subplot(2,2,3),plot(real(b1))
title('插值后信号');

c1 = (b1(1:K:Max*K-K+1));


subplot(2,2,4),plot(abs(K*c1-a));
title('复原信号与原信号差');


%{

figure
plot(abs(b3));
figure
plot(b4)
%}

end

