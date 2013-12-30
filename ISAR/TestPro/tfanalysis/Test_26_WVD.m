function Test_26_WVD
%TEST_26_WVD Summary of this function goes here
%   Detailed explanation goes here

K = 1024;
T1 = 50;
T2 = 60;

a =(-K/2:K/2-1)/(K/T1);
a = exp(-1i*a.^2);
b = (-K/2:K/2-1)/(K/T2);
b = exp(-1i*b.^2);

input = a+b;
plot(real(input))

[tfr,t,f] = tfrwv(input.');
%[tfr,t,f] = tfrspwv(a.');
%[tfr,t,f] = tfrstft(a.');

figure,contour(t,f,abs(tfr));

end

