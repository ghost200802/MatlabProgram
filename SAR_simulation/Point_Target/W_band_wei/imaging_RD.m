function imaging_RD
%IMAGE Summary of this function goes here
%   Detailed explanation goes here
clc
close all
clear all

[ Fc,~,~,B,PRF,~,c,H0,~,L_min,L_max,~,~,~,~,Vr ] = ParametersSystem();
beta = 2.5;         %匹配滤波所加的凯泽窗的系数

[signal_process,signal_reference] = ReturnSimulate();

myshow(real(signal_process));
title('原始数据实部');
%%
%距离向压缩
[A_scale R_scale] = size(signal_process);
signal_fft = (FFTX(signal_process));

i_pulselength = length(signal_reference);
window =  kaiser(i_pulselength,beta);            %对滤波器进行加窗处理
signal_reference = signal_reference.*window.';
signal_reference_fixed = zeros(1,R_scale);
signal_reference_fixed(1:i_pulselength) = signal_reference;
reference_fft = conj((FFTX(signal_reference_fixed)));
signal_process = zeros(A_scale,R_scale);
for i = 1:A_scale
    signal_process(i,:) = (signal_fft(i,:).*reference_fft);
end
signal_process = IFFTX(signal_process);
valid_length = R_scale-i_pulselength+1;      %去除弃置区，因使用的是对复制脉冲后补零的方法，所以弃置区在数据区的最后部分
signal_process = signal_process(:,1:valid_length);
R_scale = valid_length;
myshow(signal_process);
title('距离压缩结果');
%%
%RCMC
signal_process = FFTY(signal_process);

%shiftArray = zeros(R_scale,A_scale);
R_min = sqrt(H0^2+L_min^2);
R_max = sqrt(H0^2+L_max^2);
R = R_min + (R_max-R_min)/R_scale*(1:R_scale);

for i = 1:A_scale
    shift = (-1/8) * (c/Fc)^2 * R * (round(i-A_scale/2)/A_scale*PRF)^2 / Vr^2 * 2*B/c;
    %shiftArray(:,i) = shift.';
    interpPoints = (1:R_scale) - shift;
    signal_process(i,:) = interp1(1:R_scale,signal_process(i,:),interpPoints,'spline');
end
%figure,plot(shiftArray(10,:))
%figure,plot(shiftArray(200,:))
%%
%方位向压缩
Ka = 2*Vr^2/(c/Fc)./R;
Haz = zeros(A_scale,R_scale);
for i = 1:R_scale
    Haz(:,i) = (exp(-1i*pi*(round((1:A_scale)-A_scale/2)/A_scale*PRF).^2/Ka(i))).';
end
signal_process = signal_process .* Haz;
signal_process = IFFTY(signal_process);
myshow(signal_process)
title('方位压缩结果');

Point_Analyse_sure(signal_process,32,64)
end