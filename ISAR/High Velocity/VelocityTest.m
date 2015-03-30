function VelocityTest
%VELOCITYTEST Summary of this function goes here
%   Detailed explanation goes here
[ F0,F_sample,B,~,T_pulse,~,c ] = ParametersSystem();

T_sample = 1/F_sample;   %ϵͳ����ʱ�䣬��λΪ��

K = B/T_pulse;          %�źŵĵ�Ƶ��

i_pulseLength = round(T_pulse/T_sample); %�����������г���
i_pulse = 1:i_pulseLength; %�����������������
i_pulse = i_pulse*T_sample; %���������ʱ������ź�

%%
%���ɲο��ź�
%signal_reference = exp(1i*(2*pi*F0*i_pulse_1/(1+2*V0/c)+pi*K/(1+(-1)*V0/c)*i_pulse_1.^2));
V0 = 250;
alpha = (c-V0)/(c+V0);
signal_reference = exp(1i*(2*pi*F0*alpha*i_pulse+pi*K*alpha^2*i_pulse.^2));
%signal_reference = exp(1i*(2*pi*F0*i_pulse+pi*K*i_pulse.^2));
signal_return = exp(1i*(2*pi*F0*alpha*i_pulse+pi*K*alpha^2*i_pulse.^2));

signal_reference_fft = conj((fft(signal_reference)));

signal_return_fft = fft(signal_return);


signal_out_fft = ((fftshift(signal_reference_fft).*fftshift(signal_return_fft)));
%figure,plot(abs(signal_out_fft));

[x,y] = size(signal_out_fft);
signal_out_fft_p = zeros(x,10*y);
signal_out_fft_p(:,1:y) = signal_out_fft;
%figure,plot(abs(signal_out_fft_p))

signal_out_p = (ifft(signal_out_fft_p));
signal_out_p = circshift(signal_out_p,[0,100]);
signal_out_p = signal_out_p(1,1:500);
figure(1),plot(abs(signal_out_p)),hold on;
%figure(2),plot(20*log10(abs(signal_out_p)/max(abs(signal_out_p)))),hold on;


end

