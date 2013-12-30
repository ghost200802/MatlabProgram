function C4P2
%4P21 Summary of this function goes here
%   Detailed explanation goes here
close all;
clear all;

N = 100;
x = linspace(0,1,N);
y = -(x-0.5).^2;
plot(y,'r-');
hold on
h = [1 1 1 1 0 0 0 0 0 0];
y = conv(y,h);
plot(y,'g*');
y = wiener1(y,h);
plot(y,'b+');

end

