clear all;           %这个程序用来画图
dSR=0.01;               %SR计算差值
SR_max=1.6;          %SR计算最大值
x=1:dSR:SR_max;
for i=1:fix((SR_max-1)/dSR)+1
    y(i)=Caculate_AASR(x(i));
end
plot(x,10*log(y)/log(10))