function  Imaging
%IMAGING Summary of this function goes here
%   Detailed explanation goes here
close all;
clear all;
clc;
%%
%初始化
NeedRA = 0;
NeedPC = 0;
NeedKeystone = 1;
NeedCRRC = 1;
NeedDFTShift = 0;
NeedTFR = 0;

beta = 2.5;         %匹配滤波所加的凯泽窗的系数
%[ F0,F_sample,B,PRF,T_pulse,T_measure,c ] = ParametersSystem();
%[ L0,L_range,Omega,V0,a] = ParametersTarget();
load('ReturnSimulate_9_4dx.mat');
signal_process = signal_return;

%signal_process = signal_return(:,1:250);
%signal_process = signal_return(:,251:500);
%signal_process = signal_return(:,501:750);
%signal_process = signal_return(:,751:1000);


figure,imshow(abs(signal_process.')/max(max(abs(signal_process)))),colormap(gray);
title('回波信号图');
%%
%距离向压缩
[R_scale A_scale] = size(signal_process);
signal_fft = (FFTY(signal_process));
figure,imshow(abs((signal_fft).')/max(max(abs(signal_fft)))),colormap(gray);
title('回波信号多普勒域图');


i_pulselength = length(signal_reference);
window =  kaiser(i_pulselength,beta);            %对滤波器进行加窗处理
signal_reference = signal_reference.*window;
signal_reference_fixed = zeros(1,R_scale);
signal_reference_fixed(1:i_pulselength) = signal_reference;
reference_fft = conj((FFTX(signal_reference_fixed))).';
signal_process = zeros(R_scale,A_scale);
for i = 1:A_scale
    signal_process(:,i) = (signal_fft(:,i).*reference_fft);
end
signal_process = IFFTY(signal_process);
valid_length = R_scale-i_pulselength+1;      %去除弃置区，因使用的是对复制脉冲后补零的方法，所以弃置区在数据区的最后部分
signal_process = signal_process(1:valid_length,:);     
figure,imagesc(abs(signal_process.')/max(max(abs(signal_process)))),colormap(gray);
title('距离压缩结果');
%%
%越距离单元徙动校正及方位FFT成像
%Keystone算法
if(NeedKeystone)
    signal_process = Keystone(signal_process);
    %save('signal_process_afterKeystone.mat','signal_process');
    figure,imagesc(abs(signal_process.')/max(max(abs(signal_process)))),colormap(gray);
    title('Keystone校正结果');
end
%%
%包络对齐
if(NeedRA)
    tic
    signal_process = RangeAlignment(signal_process);
    toc
end
%%
%初相校正
if(NeedPC)
    signal_process = PhaseCorrection(signal_process);
end
%%

%二阶相位校正
if(NeedCRRC)
    [Omega] = calculateRotateSpeed(signal_process);
    signal_process = CRRC(signal_process,Omega);
    figure,imagesc(abs(signal_process.')/max(max(abs(signal_process)))),colormap(gray);
    title('CRRC校正结果');
end

signal_process = signal_process.';

[A_scale,R_scale] = size(signal_process);
%%
%对角速度变化做补偿
if(NeedDFTShift)
    K = 0.051;
    signal_process = DFT(signal_process,K);
else
    signal_process = FFTY(signal_process);
end

if(NeedTFR)
    myshow(signal_process);
    output = zeros(A_scale,R_scale);    
    h_tfr = waitbar(0,'进行时频成像中');
    for m = 1:A_scale      
        
%         temp = tfrstft(signal_process(:,m));
%         myshow(temp);
%         temp = tfrwv(signal_process(:,m));
%         myshow(temp);
        temp = tfrspwv(signal_process(:,m));
%         myshow(temp);
        
        output(:,m) = temp(:,100);
        waitbar(m/A_scale);
    end    
    close(h_tfr);
    myshow(fftshift(output,1));
end

%%
%结果图像处理

save('ImagingResult.mat','signal_process');


%%
%显示结果
%{
figure
mesh(abs(signal_process));
%}
myshow(signal_process);
title('成像结果黑白图');
end

