function Test_7
%TEST_7 Summary of this function goes here
%   Detailed explanation goes here
close all;
Fc = 5e1;
Fc = 0;
F_sample = 4e2;
T_sample = 1/F_sample;
B = 1e1;
F0 = Fc-B;
%F0 =0;

length = 1000;

i = 1:length;
i = i*T_sample;
T_pulse = length*T_sample;
K = B/T_pulse;

a = exp(1i*2*pi*F0*i+1i*pi*K*i.^2);
figure,plot(real(a));
figure,plot(imag(a));
b = fft(a);
c = fftshift(b);
figure,plot(abs(c));

c = abs(c);
c_max = max(abs(c));
valid_c = c>0.5*c_max;
left = find(valid_c,1,'first')-(length/2+1)
right = find(valid_c,1,'last')-(length/2+1)
mid = (left+right)/2
length = right - left +1
end

