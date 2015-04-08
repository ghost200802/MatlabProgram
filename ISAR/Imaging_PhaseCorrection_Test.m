function  Imaging_PhaseCorrection_Test
%IMAGING Summary of this function goes here
%   Detailed explanation goes here
close all;
clear all;
clc;
%%
%初始化
NeedCA = 1; %重心对齐
NeedKeystone = 1; %need
NeedRA = 1;
NeedPC = 1;
NeedCRRC = 1; %need
NeedDFTShift = 0;
NeedTFR = 0;

load('PhaseCorrectionTest.mat');

%%
%初相校正
if(NeedPC)
    signal_process = PGA(signal_process);
end

myshow(FFTX(signal_process));
title('成像结果黑白图');

maxPoint1 = imageMaxPointDB(FFTX(signal_process))
entropy1 = imageEntropy(FFTX(signal_process))
contrast1 = imageContrast(FFTX(signal_process))
%%
%二阶相位校正
if(NeedCRRC)
    [Omega] = calculateRotateSpeed(signal_process);
    signal_process = CRRC(signal_process,Omega);
    %figure,imagesc(abs(signal_process.')/max(max(abs(signal_process)))),colormap(gray);
    %title('CRRC校正结果');
end

signal_process = signal_process.';

[A_scale,R_scale] = size(signal_process);
%%
%对角速度变化做补偿
if(NeedDFTShift)
    K = 0.045;
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

maxPoint2 = imageMaxPointDB(signal_process)
entropy2 = imageEntropy(signal_process)
contrast2 = imageContrast(signal_process)

%%
%显示结果
%{
figure
mesh(abs(signal_process));
%}
save('plane_result.mat','signal_process');
myshow(signal_process);
title('成像结果黑白图');
myshow(signal_process);
end

