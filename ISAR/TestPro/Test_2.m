function Test_2
%TEST_2 Summary of this function goes here
%   Detailed explanation goes here

a = 1:10000;

tic
fft(a);
toc

tic
a.*log(a);
toc

end

