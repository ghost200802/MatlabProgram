function  Imaging_MC_test
%IMAGING Summary of this function goes here
%   Detailed explanation goes here
close all;
clear all;
clc;
%%
%初始化
NeedWriteImage = 1;
NeedCA = 1; %重心对齐
NeedKeystone = 1; %need
NeedRA = 1;
NeedPC = 1;
NeedCRRC = 0; %need
NeedDFTShift = 0;
NeedTFR = 0;

beta = 2.5;         %匹配滤波所加的凯泽窗的系数
[ F0,F_sample,B,PRF,T_pulse,T_measure,c ] = ParametersSystem();
%[ L0,L_range,Omega,V0,a] = ParametersTarget();

% 载入数据
% ReturnSimulate();
%load('ReturnSimulate_test1.mat');

%load('ReturnSimulate_v0_a0_2_0.mat');
%load('ReturnSimulate_9_4dx.mat');
%load('ReturnSimulate_plane1.mat');
load('ReturnSimulate_plane2.mat');

signal_process = signal_return;



% figure,imshow(abs(signal_process.')/max(max(abs(signal_process)))),colormap(gray);
% title('回波信号图');
%%
%距离向随机位移

% [R_scale A_scale] = size(signal_process);
% for i = 1:A_scale
%    signal_process(:,i) = circshift(signal_process(:,i),[round(rand(1)*1),0]);
% end

%%
%距离向压缩
tic
signal_fft = (FFTY(signal_process));
% figure,imshow(abs((signal_fft).')/max(max(abs(signal_fft)))),colormap(gray);
% title('回波信号多普勒域图');

[R_scale A_scale] = size(signal_process);

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
[R_scale A_scale] = size(signal_process);
figure,imagesc(abs(signal_process.')/max(max(abs(signal_process)))),colormap(gray);
title('距离压缩结果');
toc

%%
%重心对齐
signal_center = zeros(1,A_scale);
for i = 1:A_scale
    signal_center(i) = floor(sum((1:R_scale).' .* abs(signal_process(:,i)))/sum(abs(signal_process(:,i))));
end
if(NeedCA)
    
    figure,plot(signal_center)
    ka = polyfit(1:A_scale,signal_center,3);
    signal_center = ka(1)*(1:A_scale).^3+ka(2)*(1:A_scale).^2+ka(3)*(1:A_scale);
    figure,plot(signal_center)

    if(true)
        signal_process = FFTY(signal_process);
        for i = 1:A_scale 
            signal_process(:,i) =signal_process(:,i)*(exp(1j*2*2*pi*signal_center(i)*c/2/B/(c/F0))); %这里是双程，所以是两倍
        end
        signal_process = IFFTY(signal_process);
    end
end
%%
%包络对齐
if(NeedRA)
    tic
    signal_process = RangeAlignment(signal_process,signal_center);
    toc
    if(NeedWriteImage)
        imwrite(abs(signal_process')/max(max(abs(signal_process))),'Imaging_MC_test_4包络对齐结果.tiff','tiff');
    end
end
%%
%初相校正
if(NeedPC)
    signal_process = PhaseCorrection_Doppler(signal_process);
end
%%
tic
%越距离单元徙动校正及方位FFT成像
%Keystone算法
if(NeedKeystone)
    signal_process = Keystone(signal_process);
    %save('signal_process_afterKeystone.mat','signal_process');
    figure,imagesc(abs(signal_process.')/max(max(abs(signal_process)))),colormap(gray);
    title('Keystone校正结果');
end

[A_scale,R_scale] = size(signal_process);

toc


%%
tic
%二阶相位校正
if(NeedCRRC)
     [Omega] = calculateRotateSpeed(signal_process)
    %Omega = 0.102;
    %Omega = 0.092;
    %Omega = 0.095;
    signal_process = CRRC(signal_process,Omega);
    figure,imagesc(abs(signal_process.')/max(max(abs(signal_process)))),colormap(gray);
    title('CRRC校正结果');
end
toc


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

%%
%显示结果
%{
figure
mesh(abs(signal_process));
%}
save('plane_result.mat','signal_process');
myshow(signal_process);
title('成像结果黑白图');
if(NeedWriteImage)
    imwrite(abs(signal_process)/max(max(abs(signal_process))),'Imaging_MC_test_5相位补偿前.tiff','tiff');
    %imwrite(abs(signal_process)/max(max(abs(signal_process))),'Imaging_MC_test_6成像结果黑白图.tiff','tiff');
end
end

