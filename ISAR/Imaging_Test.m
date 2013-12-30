function  Imaging
%IMAGING Summary of this function goes here
%   Detailed explanation goes here
close all;
clear all;
%%
%初始化
NeedRA = 0;
NeedKeystone = 0;
NeedMTRC = 0;
NeedSRRC = 0;
beta = 2.5;         %匹配滤波所加的凯泽窗的系数
[ F0,F_sample,B,PRF,T_pulse,T_measure,c ] = ParametersSystem();
tic
[signal_process signal_reference] = ReturnSimulate;
toc
figure,imshow(abs(signal_process)/max(max(abs(signal_process)))),colormap(gray);
title('回波信号图');
%%
%距离向压缩
[R_scale A_scale] = size(signal_process);
signal_fft = (fft(signal_process));
figure,imshow(abs(fftshift(signal_fft,1))/max(max(abs(signal_fft)))),colormap(gray);
title('回波信号多普勒域图');
i_pulselength = length(signal_reference);
window =  kaiser(i_pulselength,beta);            %对滤波器进行加窗处理
signal_reference = signal_reference.*window;
signal_reference_fixed = zeros(1,R_scale);
signal_reference_fixed(1:i_pulselength) = signal_reference;
reference_fft = conj((fft(signal_reference_fixed))).';
signal_process = zeros(R_scale,A_scale);
for i = 1:A_scale
    signal_process(:,i) = (signal_fft(:,i).*reference_fft);
end
signal_process = ifft(signal_process);
valid_length = R_scale-i_pulselength+1;      %去除弃置区，因使用的是对复制脉冲后补零的方法，所以弃置区在数据区的最后部分
signal_process = signal_process(1:valid_length,:);     
figure,imagesc(abs(signal_process)/max(max(abs(signal_process)))),colormap(gray);
title('距离压缩结果');
%%
%包络对齐
if(NeedRA)
    tic
    signal_process = RangeAlignment(signal_process);
    toc
end
%%
%初相校正
%signal_process = PhaseCorrection(signal_process);
%%
%越距离单元徙动校正及方位FFT成像
%Keystone算法
if(NeedKeystone)
    signal_process = Keystone(signal_process);
    figure,imagesc(abs(signal_process)/max(max(abs(signal_process)))),colormap(gray);
    title('Keystone校正结果');
end
%这是自己写的方法，还有些问题
if(NeedSRRC)
    figure,imagesc(abs(signal_process)/max(max(abs(signal_process)))),colormap(gray);
    title('SRRC校正结果');
end
if(NeedMTRC)
    signal_process = MTRC(signal_process);
else
    signal_process = fftshift(fft(signal_process.'),1).';
end
%%
%结果图像处理
output = abs(signal_process)/max(max(abs(signal_process)));
output = output;
%%
%显示结果
%{
figure
mesh(output);
%}
figure,contour(output),colormap(jet);  %contour在图像较为复杂的时候计算时间非常长，当图像复杂时慎用
title('成像结果轮廓图');
figure,imagesc(output),colormap(gray),colormap(gray);
title('成像结果黑白图');

testfft = ifftshift(ifft(output),1);
figure,imagesc(real(testfft)),colormap(gray);
end

