function  Test_3
%TEST_3 Summary of this function goes here
%   Detailed explanation goes here
%������˵����Ƶ����ʱ���ֵֻ�Ե����źţ����縴ָ���źţ����ã���˫���źţ��������źţ��������
clear all;
close all;

Max = 20;

a = 1:Max;
a = exp(1i*0.23*pi*a);
figure
subplot(2,2,1),plot(real(a));
title('ԭʼ�ź�');

K = 10;

fft_a = fft(a);
fft_a1 = zeros(1,Max*K);
fft_a2 = zeros(1,Max*K);

fft_a1(1:Max) = fft_a;

subplot(2,2,2),plot(abs(fft_a))
title('�ź�Ƶ��');

fft_a2(1:K:Max*K-K+1) = fft_a;


b1 = ifft(fft_a1);
b2 = ifft(fft_a2);

fft_a1 = fftshift(fft_a1);
fft_a2 = fftshift(fft_a2);

b3 = ifftshift(ifft(fft_a1));
b4 = ifftshift(ifft(fft_a2));


subplot(2,2,3),plot(real(b1))
title('��ֵ���ź�');

c1 = (b1(1:K:Max*K-K+1));


subplot(2,2,4),plot(abs(K*c1-a));
title('��ԭ�ź���ԭ�źŲ�');


%{

figure
plot(abs(b3));
figure
plot(b4)
%}

end

