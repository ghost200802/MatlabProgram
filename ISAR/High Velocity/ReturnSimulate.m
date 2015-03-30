function [signal_return,signal_reference] = ReturnSimulate
%RETURNSIMULATE Summary of this function goes here
%   Detailed explanation goes here
%�������������лز���ģ��


%%
%���ԭʼ���ݼ�������ݼ���
[ L0,L_range,Omega0,dOmega,ddOmega,dddOmega,V0,Vtrac] = ParametersTarget();
[ F0,F_sample,B,PRF,T_pulse,~,c ] = ParametersSystem();
[target,N_target] = Target();
T_sample = 1/F_sample;   %ϵͳ����ʱ�䣬��λΪ��
L_min = L0-L_range;     %����������ݶ�Ӧ��Ŀ����룬Ҳ����С�Ľ������ݵľ���
L_max = L0+L_range;     %����������ݶ�Ӧ��Ŀ����룬Ҳ�����Ľ������ݵľ���
T_min = 2*L_min/c;      %����Ľ�������ʱ��
T_max = 2*L_max/c;      %����Ľ�������ʱ��
K = B/T_pulse;          %�źŵĵ�Ƶ��
%n_pulse = round(T_measure*PRF); %�ܹ��ķ�����������
n_pulse = 1;
i_pulseLength = round(T_pulse/T_sample); %�����������г���
i_pulse = 1:i_pulseLength; %�����������������
i_pulse = i_pulse*T_sample; %���������ʱ������ź�
i_receive = round((T_max-T_min)/T_sample)+i_pulseLength; %ÿ������Ľ��մ��������г���

%%
%��ʼ��
signal_return_real = zeros(n_pulse,i_receive);
signal_return_imag = zeros(n_pulse,i_receive);   

targetOmega = zeros(1,n_pulse);

%%
%���ɲο��ź�
i_pulseLength_1 = round(i_pulseLength*(1+2*V0/c));
i_pulse_1 = 1:i_pulseLength_1; %�����������������
i_pulse_1 = i_pulse_1*T_sample; %���������ʱ������ź�
signal_reference = exp(1i*(2*pi*F0*i_pulse_1/(1+2*V0/c)+pi*K/(1+(-1)*V0/c)*i_pulse_1.^2));
%signal_reference = exp(1i*(2*pi*F0*i_pulse+pi*K*i_pulse.^2));
%%
%���ɻز�����
h1 = waitbar(0,'��������');
for i = 1:n_pulse
    L = L0+V0*(i/PRF);            %����Ŀ��λ��
    Omega = Omega0+dOmega*(i/PRF);
    dOmega = dOmega + ddOmega*(i/PRF);
    ddOmega = ddOmega + dddOmega*(i/PRF);
    targetOmega(i) = Omega;
    [targetRCS,targetDistance] = CaculateTarget(target,N_target,L,Omega,i/PRF,i_pulseLength,T_sample,V0);
    for k = 1:N_target
        if N_target == 1  %���ֻ��1��Ŀ�꣬�������˻�����Ҫ���⴦��
            t_return = 2*targetDistance/c - T_min;
        else
            t_return = 2*targetDistance(k)/c - T_min;                                     %�����Ǵ�T_min��ʼҲ���Ǵӽ��ջز���ʼ��ʱ���ʱ�䣬Ϊ����ز����յ����ݽ����Ǻ�
        end
        t_trac_shift = 2*Vtrac*(i/PRF)/c;    %����Ŀ����ٽ��е�ʱ����ƽ��
        i_return_real = round((t_return)/T_sample);                                              %�����������ڵڼ�����������ʱ��ʼ���յ��ز��ź�
        i_return_trac = round((t_return-t_trac_shift)/T_sample);
        signal_return_target = targetRCS(k)*exp(1i*(2*pi*F0*(i_pulse-(t_return-i_return_real*T_sample))+pi*K*(i_pulse-(t_return-i_return_real*T_sample)).^2));                  %����ÿ��Ŀ��Ļز�
        signal_return_real(i,i_return_trac : i_return_trac+i_pulseLength-1) = signal_return_real(i,i_return_trac : i_return_trac+i_pulseLength-1)+real(signal_return_target); %��ÿ��Ŀ��Ļز����ӽ�����Ľ��ջز�
        signal_return_imag(i,i_return_trac : i_return_trac+i_pulseLength-1) = signal_return_imag(i,i_return_trac : i_return_trac+i_pulseLength-1)+imag(signal_return_target);
    end
    waitbar(i/n_pulse);
end
delete(h1);
signal_return = complex(signal_return_real,signal_return_imag);
%%
%��ʾ���
%{
figure
plot(real(signal_return(1,:)));
title('��1������Ļز��ź�');
figure
plot(real(signal_reference));
title('�ο��ź�');
%}
% ����Ŀ��ת�����ٶ�
% time = (1:n_pulse)*0.5/n_pulse;
% figure,plot(time,targetOmega)
% title('Ŀ��ת�����ٶ�')
% xlabel('����ʱ��')
% ylabel('���ٶ�(rad/s)')
%%
%��������и�ʽƥ��
signal_return  = signal_return.';
signal_reference = signal_reference.';
end

