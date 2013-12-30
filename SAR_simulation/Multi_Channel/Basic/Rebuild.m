function  Rebuild
%REBUILD Summary of this function goes here
%   Detailed explanation goes here
close all;
clear all;
clc

[ Vs,F0,Lamda,H,Br,La,N,daz,c ] = Parameters();

PRF=1600;

raw_data =Raw_Data(PRF,1);
raw_data2 = Raw_Data(PRF,2);


e_raw_data2=zeros(3,3000);                   %下面进行补零插值

for m=1:3
    for n=1:1000
        e_raw_data2(m,3*n-(3-m))=raw_data2(m,n);
    end
end

f_raw_data = fftshift(fft(raw_data));

f_e_raw_data2=zeros(3,3000);
f_e_raw_data2(1,:)=fftshift(fft(e_raw_data2(1,:)));             %对输入信号FFT
f_e_raw_data2(2,:)=fftshift(fft(e_raw_data2(2,:)));
f_e_raw_data2(3,:)=fftshift(fft(e_raw_data2(3,:)));

daz1 = daz*1496/PRF;

PRF=1496;

Hf = zeros(N,N);
P = zeros(N,3000);



for i = 1:PRF    
    for m = 1:N
        for n= 1:N
            Hf(m,n) = exp(-j*pi*(((N+1)/2-m)*daz1)^2/2/Lamda/H)*exp(-j*pi*((N+1)/2-m)*daz1*(i-(round(PRF/2))+(n-1)*PRF)/Vs);
        end
    end
    P = Hf^-1;
    P1(:,i) = P(:,1);
    P2(:,i) = P(:,2);
    P2 = P2./(exp(-j*pi*((N+1)/2-m)*daz1*(1*PRF)/Vs));
    P3(:,i) = P(:,3);
    P3 = P3./(exp(-j*pi*((N+1)/2-m)*daz1*(2*PRF)/Vs));
end

W1 = zeros(3,PRF);
W2 = zeros(3,PRF);
W3 = zeros(3,PRF);

half_PRF = round(PRF/2);
T1 = 1501-half_PRF;
T2 = 1501+half_PRF;

W1(:,1:T1) = f_e_raw_data2(:,1:T1);
W2(:,1:T2-T1) = f_e_raw_data2(:,T1+1:T2);
W3(:,PRF+T2-3000+1:PRF) = f_e_raw_data2(:,T2+1:3000);

r_W1=sum(W1.*P1);
r_W2=sum(W2.*P2);
r_W3=sum(W3.*P3);

f_re_data = zeros(1,N*PRF);
f_re_data(1:PRF) = r_W3;
f_re_data(PRF+1:2*PRF) = r_W2;
f_re_data(2*PRF+1:3*PRF) = r_W1;

figure
plot(abs(sum(f_e_raw_data2)));
figure
plot(abs(f_re_data));
end

