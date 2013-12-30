function Test_8
%TEST_8 Summary of this function goes here
%   Detailed explanation goes here
a = [1 2 3;4 5 6;7 8 9];
fft_a = fft(a);
shift_a = fftshift(a,1);

ifft_a = ifft(fft_a)

fftshift(ifft_a)
ifftshift(ifft_a)



end

