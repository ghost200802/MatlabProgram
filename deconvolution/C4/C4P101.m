function  C4P101
%C4P101 Summary of this function goes here
%   Detailed explanation goes here
close all;
clear all;
%Tϵͳ��ͬ���������
T=3;
M=5;
t=(0:M)*T;
hn=(1-exp(-0.5*t)).*exp(-0.8*t);
L=20;
dn=randn(1,L);
yn=conv(dn,hn);
t0=0:20/(L+M):20-(20/(L+M));
stem(t0,yn)
xlabel('t');
ylabel('����');
title('ϵͳͬ���������');
%�������������
t=0:M*T;
hn1=(1-exp(-0.5*t)).*exp(-0.8*t);
dn1=zeros(1,3*L);
dn1(1:3:3*L-2)=dn;
yn1=conv(dn1,hn1);
t0=0:20/(3*(L+M)):20-(20/(3*(L+M)));
figure
stem(t0,yn1)
title('����������');
xlabel('t');
ylabel('����');

end

