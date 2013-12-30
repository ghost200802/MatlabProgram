function  wave
close all;
A=1;                 %电场场强
w=1;
f=0.995;

t=0.01:0.01:10;
e=A*cos(2*pi*w.*t);  %电场在自由空间传播为正弦波

A=zeros(1,1000);     
A(1)=1;
for i=2:1000
    A(i)=A(i-1)*f;
end
k=A.*cos(2*pi*w.*t); %有损传播时为振幅按比例损失

comet(t,e);          %无损耗传播
comet(t,k);          %有损耗传播

end
