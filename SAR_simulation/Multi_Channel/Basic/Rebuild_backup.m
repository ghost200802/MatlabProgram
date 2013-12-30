function  Rebuild
%REBUILD Summary of this function goes here
%   Detailed explanation goes here
close all;
clear all;
clc

[ Vs,F0,Lamda,H,Br,La,N,daz,c ] = Parameters();

PRF=1600;
raw_data = Raw_Data(PRF,2);

e_raw_data=zeros(3,3000);                   %下面进行补零插值

for m=1:3
    for n=1:1000
        e_raw_data(m,3*n-(3-m))=raw_data(m,n);
    end
end

daz1 = daz*1495/PRF;

A=-pi*daz1/Vs;                                        %求逆矩阵里面的几个常数
B=exp(2*j*A*PRF)-exp(-2*j*A*PRF)-2*(exp(j*A*PRF)-exp(-j*A*PRF));

P=zeros(3,3000);                                    %重建滤波器矩阵（结果完全不对）

f_raw_data=zeros(3,3000);


f=1:(1500-round(PRF/2));
P(1,1:(1500-round(PRF/2)))=(exp(j*A*(f+2*PRF))-exp(j*A*(f+PRF)))/B;
f=(1501-round(PRF/2)):(1501+round(PRF/2));
P(1,(1501-round(PRF/2)):(1501+round(PRF/2)))=(exp(j*A*PRF)-exp(-j*A*PRF))/B;
f=(1501+round(PRF/2)):3000;
P(1,(1501+round(PRF/2)):3000)=(exp(-j*A*(f+PRF))-exp(-j*A*(f+2*PRF)))/B;

f=1:(1500-round(PRF/2));
P(2,1:(1500-round(PRF/2)))=(exp(j*A*(f+2*PRF))-exp(j*A*(f)))/B;
f=(1501-round(PRF/2)):(1501+round(PRF/2));
f=f-PRF;
P(2,(1501-round(PRF/2)):(1501+round(PRF/2)))=(exp(2*j*A*PRF)-exp(-2*j*A*PRF))/B;
f=(1501+round(PRF/2)):3000;
f=f-2*PRF;
P(2,(1501+round(PRF/2)):3000)=(exp(-j*A*(f))-exp(-j*A*(f+2*PRF)))/B;

f=1:(1500-round(PRF/2));
P(3,1:(1500-round(PRF/2)))=(exp(j*A*(f+PRF))-exp(j*A*(f)))/B;
f=(1501-round(PRF/2)):(1501+round(PRF/2));
f=f-PRF;
P(3,(1501-round(PRF/2)):(1501+round(PRF/2)))=(exp(j*A*PRF)-exp(-j*A*PRF))/B;
f=(1501+round(PRF/2)):3000;
f=f-2*PRF;
P(3,(1501+round(PRF/2)):3000)=(exp(-j*A*(f))-exp(-j*A*(f+PRF)))/B;


f_raw_data(1,:)=fftshift(fft(e_raw_data(1,:)));             %对输入信号FFT
f_raw_data(2,:)=fftshift(fft(e_raw_data(2,:)));
f_raw_data(3,:)=fftshift(fft(e_raw_data(3,:)));

f_R=sum(f_raw_data.*P);                                     %重建滤波


figure
plot(abs(sum(f_raw_data)))                                  %原始信号频谱
figure
plot(real(P(1,:)))                                          %部分重建滤波器的实部
figure
plot(abs(f_R));                                             %重建信号频谱（太诡异了）

end

