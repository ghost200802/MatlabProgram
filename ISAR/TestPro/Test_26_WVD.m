function Test_26_WVD
%TEST_26_WVD Summary of this function goes here
%   Detailed explanation goes here
close all

K = 1000;
T = 30;


a =(-K/2:K/2-1)/(K/T);
a = exp(-1i*a.^2);
b = ((-K/2:K/2-1)+K/4)/(K/T);
b = exp(-1i*b.^2);
a = a+b;
plot(real(a))

[tfr,t,f] = tfrwv(a.');

tfr = fftshift(tfr,1);

tfr = abs(tfr);
tfr = tfr/max(max(tfr));

figure,imagesc(t,f,tfr),colormap(gray)


end

