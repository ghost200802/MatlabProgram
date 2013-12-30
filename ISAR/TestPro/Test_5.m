function Test_5
%TEST_5 Summary of this function goes here
%   Detailed explanation goes here
tic
col = 1e3;
rol = 1e5;
a = ones(col,rol);
fft_a = fft(a);
toc

end

