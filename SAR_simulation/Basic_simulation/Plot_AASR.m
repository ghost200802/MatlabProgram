clear all;           %�������������ͼ
dSR=0.01;               %SR�����ֵ
SR_max=1.6;          %SR�������ֵ
x=1:dSR:SR_max;
for i=1:fix((SR_max-1)/dSR)+1
    y(i)=Caculate_AASR(x(i));
end
plot(x,10*log(y)/log(10))