function  wave
close all;
A=1;                 %�糡��ǿ
w=1;
f=0.995;

t=0.01:0.01:10;
e=A*cos(2*pi*w.*t);  %�糡�����ɿռ䴫��Ϊ���Ҳ�

A=zeros(1,1000);     
A(1)=1;
for i=2:1000
    A(i)=A(i-1)*f;
end
k=A.*cos(2*pi*w.*t); %���𴫲�ʱΪ�����������ʧ

comet(t,e);          %����Ĵ���
comet(t,k);          %����Ĵ���

end
