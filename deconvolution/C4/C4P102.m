function [ output_args ] = C4P102( input_args )
%C4P102 Summary of this function goes here
%   Detailed explanation goes here
%T系统化同步输出序列
T=3;
M=10;
t=(0:M)*T;
hn=(1-exp(-0.5*t)).*exp(-0.8*t);
L=1000;
dn=randn(1,L);
yn=conv(dn,hn);
ync=yn(L/2:L/2+49);
Ryn=acorr1(ync);
plot(Ryn)
title('同步输出序列自相关');
%过采样输出序列
t=0:M*T;
hn1=(1-exp(-0.5*t)).*exp(-0.8*t);
dn1=zeros(1,3*L);
dn1(1:3:3*L-2)=dn;
yn1=conv(dn1,hn1);
yn1c=yn1(L*T/2:L*T/2+50*T-1);
Ryn1=acorr1(yn1c);
figure(2)
plot(Ryn1)
title('过采样输出序列自相关');

end

