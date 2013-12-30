function AASR=Caculate_AASR(SR)                         %SRΪ��������

B=0.886;                                                %3db����
df=0.001;                                               %��������
f_max=1000;                                             %Ƶ�ʼ�������
f=0:df:f_max;                                           %�����м���������Ƶ�׶Գ��ԣ�Ϊ�˼��㷽��ֻ������һ�ߣ�
Signal=abs(sinc(f));                                    %�źŹ�����
K=fix((f_max-B/2)/(SR*B));                              %�����źż������

P_sig=sum(Signal(1:fix(B/(2*df))));             

P_blur=0;
for i=1:K
    P_blur=P_blur+sum(Signal(fix((i*SR*B-B/2)/df):fix((i*SR*B+B/2)/df)));
end

AASR=P_sig/P_blur;