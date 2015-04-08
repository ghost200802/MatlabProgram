function VelocityTestDechirp
%VELOCITYTEST Summary of this function goes here
%   Detailed explanation goes here
[ F0,F_sample,B,~,T_pulse,~,c ] = ParametersSystem();

T_sample = 1/F_sample;   %系统采样时间，单位为秒

K = B/T_pulse;          %信号的调频率

i_pulseLength = round(T_pulse/T_sample); %发射脉冲序列长度
i_pulse = 1:i_pulseLength; %发射脉冲的脉冲序列
i_pulse = i_pulse*T_sample; %发射脉冲的时间采样信号

%%
%生成参考信号
%signal_reference = exp(1i*(2*pi*F0*i_pulse_1/(1+2*V0/c)+pi*K/(1+(-1)*V0/c)*i_pulse_1.^2));
V0 = 0;
alpha = (c-V0)/(c+V0);
signal_reference = zeros(1,i_pulseLength+10000);
signal_return = zeros(1,i_pulseLength+10000);
%signal_reference = exp(1i*(2*pi*F0*alpha*i_pulse+pi*K*alpha^2*i_pulse.^2));
signal_reference(1:i_pulseLength) = exp(1i*(2*pi*F0*i_pulse+pi*K*i_pulse.^2));
%signal_return = exp(1i*(2*pi*F0*alpha*i_pulse+pi*K*alpha^2*i_pulse.^2));
signal_return(5001:i_pulseLength+5000) = exp(1i*(2*pi*F0*i_pulse+pi*K*i_pulse.^2));

signal_out = signal_return.*conj(signal_reference);

figure,plot(real(signal_out))



end

