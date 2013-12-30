clear

a = 1:0.01:1.6;               %过采样因子范围
len = length(a);
temp = zeros(1,len);
B=0.886;                       %信号带宽
f=-B:0.001:B;                  %信号处理带宽范围
sig=abs(sinc(f));              %信号功率谱
%syms f a k
%a = 1.6;
%k = 2;

P_sig=trapz(f,sig);            %有用信号功率

for i = 1:len                   %求模糊信号功率
 P_amb=0;
for k=-10:10                  
    if(k)
    amb=abs(sinc(f-k*a(i)*B));        %模糊信号功率谱
    P_amb=P_amb+trapz(f,amb);
    end
end

A=P_sig/P_amb;
AASR1=10*log(A)/log(10);            %方位向模糊比
temp(i) = AASR1;
end

AASR= temp;
plot(AASR);                          %绘制AASR与过采样因子的函数图象