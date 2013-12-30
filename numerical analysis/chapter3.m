function chapter3
%CHAPTER3 Summary of this function goes here
%   Detailed explanation goes here
close all
x = linspace(-1,1,10);
y = 1./(1+25*x.^2);
p=polyfit(x,y,30);

m = linspace(-1,1,1000);
n = polyval(p,m);
k = 1./(1+25*m.^2)
plot(m,n,'red');
hold on
plot(m,k,'green');


end

