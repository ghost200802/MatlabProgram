function ReturnSimulate
%RETURNSIMULATE Summary of this function goes here
%   Detailed explanation goes here
%�������������лز���ģ��

%��û�м������߷���ͼ��������------------------------------------------
%%
%���ԭʼ���ݼ�������ݼ���
[ ~,F0,F_sample,B,PRF,T_pulse,c,H0,L0,L_min,L_max,Bw,D,d_min,d_max,Vr ] = ParametersSystem();
[target,N_target] = Target();

T_sample = 1/F_sample;                      %ϵͳ����ʱ�䣬��λΪ��
R_min = sqrt(H0^2 + L_min^2);               %����������ݶ�Ӧ��Ŀ����룬Ҳ����С�Ľ������ݵľ���
R_max = sqrt(H0^2 + L_max^2 + D^2);     %����������ݶ�Ӧ��Ŀ����룬Ҳ�����Ľ������ݵľ���
T_min = 2*R_min/c;                          %����Ľ�������ʱ��
T_max = 2*R_max/c;                          %����Ľ�������ʱ��
K = B/T_pulse;                              %�źŵĵ�Ƶ��
T_measure = (d_max - d_min)/Vr;             %�ܲ���ʱ��
n_pulse = round(T_measure*PRF);             %�ܹ��ķ�����������
i_pulselength = round(T_pulse/T_sample);    %�����������г���
i_pulse = 1:i_pulselength;                  %�����������������
i_pulse = i_pulse*T_sample;                 %���������ʱ������ź�
i_receive = round((T_max-T_min)/T_sample)+i_pulselength; %ÿ������Ľ��մ��������г���

%%
%��ʼ��
signal_return_real = zeros(n_pulse,i_receive);
signal_return_imag = zeros(n_pulse,i_receive);

%%
%���ɲο��ź�
signal_reference = exp(1i*(2*pi*F0*i_pulse+pi*K*i_pulse.^2));
%%
%���ɻز�����
h1 = waitbar(0,'��������');
for i = 1:n_pulse
    targetCondition = CaculateTarget(target,N_target,H0,L0,D,d_min+i/PRF*Vr,Bw);
    for k = 1:N_target
        if(targetCondition(k,3))
            t_return = 2*targetCondition(k,2)/c - T_min;                                      %�����Ǵ�T_min��ʼҲ���Ǵӽ��ջز���ʼ��ʱ���ʱ�䣬Ϊ����ز����յ����ݽ����Ǻ�
            i_return = round(t_return/T_sample);                                              %�����������ڵڼ�����������ʱ��ʼ���յ��ز��ź�
            signal_return_target = targetCondition(k,1)*exp(1i*(2*pi*F0*(i_pulse-(t_return-i_return*T_sample))+pi*K*(i_pulse-(t_return-i_return*T_sample)).^2));                  %����ÿ��Ŀ��Ļز�
            signal_return_real(i,i_return : i_return+i_pulselength-1) = signal_return_real(i,i_return : i_return+i_pulselength-1)+real(signal_return_target); %��ÿ��Ŀ��Ļز����ӽ�����Ľ��ջز�
            signal_return_imag(i,i_return : i_return+i_pulselength-1) = signal_return_imag(i,i_return : i_return+i_pulselength-1)+imag(signal_return_target);
        end
    end
    waitbar(i/n_pulse);
end
close(h1);
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
%%
%��������и�ʽƥ��
signal_return  = signal_return.';
signal_reference = signal_reference.';

figure
imagesc(real(signal_return)),colormap(gray)

save('ReturnSimulate.mat','signal_return','signal_reference');
end

