function  Test_6
%TEST_6 Summary of this function goes here
%   Detailed explanation goes here
tic
a = ones(1e3,1e4);
%a = ones(1,1e7);
circshift(a,[0,5]);
toc

end

