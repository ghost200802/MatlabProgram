function Test_22
%TEST_22 Summary of this function goes here
%   Detailed explanation goes here
close all
detW = 0.3;
a = sin((0:100)*pi/100);
figure,plot(a);
ffta = FFTX(a);
shift = exp(-1i*detW*2*pi*(0:100).^1);
ffta = ffta.*shift;
b = IFFTX(ffta);
figure,plot(abs(b))

end

