function plotTest
%PLOTTEST Summary of this function goes here
%   Detailed explanation goes here
close all

size = 10000;
i = 1:size;
i = i/size;
curve = 1+2*i+(-5)*i.^2+(3)*i.^3;
curve_sum = ones(1,size)*mean(curve);

plot(curve)
hold on
plot(curve_sum)

sum1 = ones(1,size/4)*mean(curve(1:size/4));
plot(1:size/4,sum1)
sum2 = ones(1,size/4)*mean(curve(size/4+1:size*2/4));
plot(size/4+1:size*2/4,sum2)
sum3 = ones(1,size/4)*mean(curve(size*2/4+1:size*3/4));
plot(size*2/4+1:size*3/4,sum3)
sum4 = ones(1,size/4)*mean(curve(size*3/4+1:size*4/4));
plot(size*3/4+1:size*4/4,sum4)


end

