function  C4P3
%C4P3 Summary of this function goes here
%   Detailed explanation goes here
close all;
clear all;

x=rand(1,128);
r=acorr1(x)
R=xcorr(x,'unbiased')
plot(r)
figure
plot(R)
end

