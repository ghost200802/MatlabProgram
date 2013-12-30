function Test
%TEST Summary of this function goes here
%   Detailed explanation goes here
close all;

i=-1000:0.001:1000;

A_filter = exp(j*pi*i.^2);

raw_data = exp(-j*pi*i.^2);

f_filter=fft(A_filter);
f_filter=fft(A_filter);
f_data=fft(raw_data);
f_out=f_filter.*f_data;
f_out=fftshift(f_out);
out=abs(fftshift(ifft(f_out)));
out=10*log10(out/max(out));

figure(2)
plot(out)

end

