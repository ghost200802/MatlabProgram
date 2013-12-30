function  Rebuild
%REBUILD Summary of this function goes here
%   Detailed explanation goes here
close all;
clear all;
clc

[ Vs,F0,Lamda,H,Br,La,N,daz,c ] = Parameters();

PRF=1600;
raw_data = Raw_Data(PRF,2);

e_raw_data=zeros(3,3000);                   %������в����ֵ

for m=1:3
    for n=1:1000
        e_raw_data(m,3*n-(3-m))=raw_data(m,n);
    end
end

daz1 = daz*1495/PRF;

A=pi*daz1/Vs;                                        %�����������ļ�������


P=zeros(3,1000);                                    %�ؽ��˲������󣨽����ȫ���ԣ�

f_raw_data=zeros(3,1000);
f_e_raw_data=zeros(3,3000);

f=1:1000;
P(1,:)=exp(j*A*f);
P(2,:)=1;
P(3,:)=exp(j*(-1)*A*f);

f_e_raw_data(1,:)=fftshift(fft(e_raw_data(1,:)));             %�������ź�FFT
f_e_raw_data(2,:)=fftshift(fft(e_raw_data(2,:)));
f_e_raw_data(3,:)=fftshift(fft(e_raw_data(3,:)));

f_raw_data(1,:)=fftshift(fft(raw_data(1,:)));
f_raw_data(2,:)=fftshift(fft(raw_data(2,:)));
f_raw_data(3,:)=fftshift(fft(raw_data(3,:)));

f_R_2=f_raw_data.*P;                                     %�ؽ��˲�

for m=1:3
    for n=1:1000
        f_R_1(3*n-(3-m))=f_R_2(m,n);
    end
end



figure
plot(abs(f_e_raw_data(1,:)))
figure
plot(abs(f_e_raw_data(2,:)))
figure
plot(abs(f_e_raw_data(3,:)))
figure
plot(abs(sum(f_e_raw_data)))                                  %ԭʼ�ź�Ƶ��
figure
plot(real(P(1,:)))                                          %�����ؽ��˲�����ʵ��
figure
plot(abs(f_R_1));                                             %�ؽ��ź�Ƶ�ף�̫�����ˣ�

end

