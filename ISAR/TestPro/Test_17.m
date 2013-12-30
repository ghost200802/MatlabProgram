function Test_17
%TEST_17 Summary of this function goes here
%   Detailed explanation goes here

tic
i = 1:100000;
k = sinc(i/100000);
toc
end

