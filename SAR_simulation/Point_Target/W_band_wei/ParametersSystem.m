function [ Fc,F0,F_sample,B,PRF,T_pulse,c,H0,L0,L_min,L_max,Bw,D,d_min,d_max,Vr,dx ] = ParametersSystem
%PARAMETERSSYSTEM Summary of this function goes here
%   Detailed explanation goes here
c = 3e8;                    %���٣���λΪ��/��
lambda = 0.0085;
Fc = c/lambda;                  %�����ź�����Ƶ�ʣ���λΪ����
F_sample = 1300e6;             %ϵͳ����Ƶ��
B = 1000e6;                  %�źŴ���
F0 = Fc-B/2;                %�����ź����Ƶ��
PRF = 8000;                 %PRF
T_pulse = 2.4e-6;             %�������ʱ�䣬��λΪ��


% H0 = 500;                   %�״�ϵͳ���и߶�
% R0 = H0*tan(65*pi/180);     %б��
% L0 = sqrt(R0^2-H0^2);       %Ŀ������ϵ����X���꣬Ĭ��Y����Ϊ0����λΪ��
% L_min = H0*tan(58*pi/180);  %��Сб��
% L_max = H0*tan(72*pi/180);  %���б��

H0 = 500;                   %�״�ϵͳ���и߶�

L0 = H0*tan(60*pi/180);       %Ŀ������ϵ����X���꣬Ĭ��Y����Ϊ0����λΪ��
R0 = sqrt(L0^2+H0^2);     %б��
L_min = H0*tan(59*pi/180);  %��Сб��
L_max = H0*tan(61*pi/180);  %���б��


Bw = 0.03;
D = R0*Bw;                  %�ϳɿ׾�����
La = 10;                    %��λ��ĺϳɳ���
d_min = (-1)*D;           %��ʼ����λ��
d_max = D+La;           %��������λ��
dx = 0.1;                   %������ߵĳ���

%59.5-69.5
Vr = 65;                   %�����ٶ�

end

