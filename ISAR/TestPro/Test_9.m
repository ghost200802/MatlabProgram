function Test_9
%TEST_9 Summary of this function goes here
%   Detailed explanation goes here
close all
k = 0.88;
m = 1:50;
n = 1:300;
n = n/6;
a = cos(2*pi*k*m).';
b = interp1(m,a,n,'spline');

subplot(2,1,1),plot(a);
subplot(2,1,2),plot(b);

end

