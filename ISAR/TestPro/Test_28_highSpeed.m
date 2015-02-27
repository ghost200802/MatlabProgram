function Test_28_highSpeed
%TEST_28_HIGHSPEED Summary of this function goes here
%   Detailed explanation goes here
clear all
close all
clc


F0 =  9.7750e+010;
F_sample =  5.0000e+009;
B =  4.5000e+009;
PRF =    4000;
T_pulse =  20e-006;
T_receive = 100e-6;
T_measure =    0.5000;
c =   300000000;
lambda = c/F0;


T_sample = 1/F_sample;   %系统采样时间，单位为秒

K = B/T_pulse;          %信号的调频率
n_pulse = round(T_measure*PRF); %总共的发射脉冲数量
i_pulselength = round(T_pulse/T_sample); %发射脉冲序列长度
i_pulse = 1:i_pulselength; %发射脉冲的脉冲序列
i_pulse = i_pulse*T_sample; %发射脉冲的时间采样信号
i_receive = round((T_receive)/T_sample)+i_pulselength; %每次脉冲的接收窗采样序列长度

v = 1000;
alpha = (c-v)/(c+v)-1
signal_transmit = exp(1i*(2*pi*F0*i_pulse+pi*K*i_pulse.^2));
signal_add = exp(1i*(2*pi*F0*i_pulse*alpha));

signal_reference = zeros(1,i_receive);
signal_target = zeros(1,i_receive);
signal_reference(1:i_pulselength) = signal_transmit.*signal_add;

signal_target(100001:100000+i_pulselength) = signal_target(100001:100000+i_pulselength)+signal_transmit;
% figure,plot(real(signal_target))

reference_fft = conj((FFTX(signal_reference)));
signal_fft = (FFTX(signal_target));

signal_process = (signal_fft.*reference_fft);

signal_process = IFFTX(signal_process);
figure,plot(abs(signal_process));

end

