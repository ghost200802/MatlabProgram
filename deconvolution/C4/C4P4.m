function  C4P4
%C4P4 Summary of this function goes here
%   Detailed explanation goes here
close all;
clear all;

e = randn(1,1000);
A = [-2.2137 2.9403 -2.1697 0.9606];
B = [1];
y = filter(B,A,e)
yn = y(500:549)
figure
plot(yn);

r = acorr1(yn);
figure
plot(r);

w=linspace(-pi/2,pi/2,1000);
a = levinson(r,5);
a1 = a(1);
a2 = a(2);
a3 = a(3);
a4 = a(4);
A=1+a1*exp(-j*w)+a2*exp(-j*2*w)+a3*exp(-j*3*w)+a4*exp(-j*4*w);
A=1./(abs(A).^2);
figure
plot(w,A)

w=linspace(-pi/2,pi/2,1000);
a1=-2.2137;
a2=2.9403;
a3=-2.1697;
a4=0.9606;
A=1+a1*exp(-j*w)+a2*exp(-j*2*w)+a3*exp(-j*3*w)+a4*exp(-j*4*w);
A=1./(abs(A).^2);
figure
plot(w,A)


w=linspace(-pi/2,pi/2,1000);
[a e] = burg(r,5);
a1 = a(1);
a2 = a(2);
a3 = a(3);
a4 = a(4);
A=1+a1*exp(-j*w)+a2*exp(-j*2*w)+a3*exp(-j*3*w)+a4*exp(-j*4*w);
A=1./(abs(A).^2);
figure
plot(w,A)


end

