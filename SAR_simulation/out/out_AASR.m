clear

a = 1:0.01:1.6;               %���������ӷ�Χ
len = length(a);
temp = zeros(1,len);
B=0.886;                       %�źŴ���
f=-B:0.001:B;                  %�źŴ������Χ
sig=abs(sinc(f));              %�źŹ�����
%syms f a k
%a = 1.6;
%k = 2;

P_sig=trapz(f,sig);            %�����źŹ���

for i = 1:len                   %��ģ���źŹ���
 P_amb=0;
for k=-10:10                  
    if(k)
    amb=abs(sinc(f-k*a(i)*B));        %ģ���źŹ�����
    P_amb=P_amb+trapz(f,amb);
    end
end

A=P_sig/P_amb;
AASR1=10*log(A)/log(10);            %��λ��ģ����
temp(i) = AASR1;
end

AASR= temp;
plot(AASR);                          %����AASR����������ӵĺ���ͼ��