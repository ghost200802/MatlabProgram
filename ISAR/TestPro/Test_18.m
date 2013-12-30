function Test_18
%TEST_18 Summary of this function goes here
%   Detailed explanation goes here
close all
clear all
clc

a = 1:50;
a = sin(a*2*pi/100);
figure,plot(a);
b = 1:500;
b = b/10;
c = SincInterpolation(a,b,8,1);
figure,plot(b,c);
hold on

end

