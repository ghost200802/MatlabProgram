function Test_21
%TEST_21 Summary of this function goes here
%   Detailed explanation goes here
close all

a = (([1:100,50:-1:1,100:-1:50])/100);
figure,plot(a)

ffta = fftshift(fft((a)));
figure,plot(abs(ffta))

ffta = [ffta,zeros(1,900)];

b = (ifft(ifftshift(ffta)));

figure,plot(abs(b))

end

