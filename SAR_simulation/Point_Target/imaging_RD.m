function imaging_RD
%IMAGE Summary of this function goes here
%   Detailed explanation goes here
clc
close all
clear all

[ Fc,~,~,~,PRF,~,c,H0,L0,~,~,~,~,~,~,Vr ] = ParametersSystem();
beta = 2.5;         %匹配滤波所加的凯泽窗的系数
interp = 8;         %插值倍数

load('ReturnSimulate.mat');
signal_process = signal_return;

myshow(real(signal_process));
title('回波信号图');
%%
%距离向压缩
[R_scale A_scale] = size(signal_process);
signal_fft = (FFTY(signal_process));

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
R_scale = valid_length;
myshow(signal_process);
title('距离压缩结果');
%%
%RCMC
signal_process = FFTX(signal_process);

[X,Y] = meshgrid(1:A_scale,1:1/interp:R_scale);
signal_process = complex(interp2(real(signal_process),X,Y,'spline'),interp2(imag(signal_process),X,Y,'spline'));

%D = sqrt(1 - (1/4) * (c/Fc)^2 * (round(i-A_scale/2)/A_scale*PRF)^2 / Vr^2);

for i = 1:A_scale
    %shift = round(sqrt(H0^2+L0^2) * (1 - D)./D *interp);
    shift = round((-1/8) * (c/Fc)^2 * sqrt(H0^2+L0^2) * (round(i-A_scale/2)/A_scale*PRF)^2 / Vr^2 * interp);
    signal_process(:,i) = circshift(signal_process(:,i),[shift,0]);
end
signal_process = signal_process(1:interp:R_scale*interp,:);
myshow(IFFTX(signal_process))
%%
%方位向压缩
Ka = 2*Vr^2/(c/Fc)/sqrt(H0^2+L0^2);
Haz = ones(1,R_scale).' * exp(-1i*pi*(round((1:A_scale)-A_scale/2)/A_scale*PRF).^2/Ka);
signal_process = signal_process .* Haz;
signal_process = IFFTX(signal_process);
myshow(signal_process)
%%
%结果显示
%figure,contour(abs(signal_process))
end