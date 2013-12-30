function AASR=Caculate_AASR(SR)                         %SR为过采样率

B=0.886;                                                %3db带宽
df=0.001;                                               %迭代步长
f_max=1000;                                             %频率计算上限
f=0:df:f_max;                                           %计算中间量（由于频谱对称性，为了计算方便只计算了一边）
Signal=abs(sinc(f));                                    %信号功率谱
K=fix((f_max-B/2)/(SR*B));                              %叠加信号计算次数

P_sig=sum(Signal(1:fix(B/(2*df))));             

P_blur=0;
for i=1:K
    P_blur=P_blur+sum(Signal(fix((i*SR*B-B/2)/df):fix((i*SR*B+B/2)/df)));
end

AASR=P_sig/P_blur;