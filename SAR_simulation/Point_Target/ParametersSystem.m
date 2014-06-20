function [ Fc,F0,F_sample,B,PRF,T_pulse,c,H0,L0,L_min,L_max,Bw,D,d_min,d_max,Vr,dx ] = ParametersSystem
%PARAMETERSSYSTEM Summary of this function goes here
%   Detailed explanation goes here

Fc = 9.375e10;                  %�����ź�����Ƶ�ʣ���λΪ����
F_sample = 700e6;             %ϵͳ����Ƶ��
B = 600e6;                  %�źŴ���
F0 = Fc-B/2;                %�����ź����Ƶ��
PRF = 4000;                 %PRF
T_pulse = 2.4e-6;             %�������ʱ�䣬��λΪ��
c = 3e8;                    %���٣���λΪ��/��

H0 = 500;                   %�״�ϵͳ���и߶�
L0 = sqrt(1000^2-500^2);    %Ŀ������ϵ����X���꣬Ĭ��Y����Ϊ0����λΪ��
L_min = L0-50;                %�״����������������
L_max = L0+50;               %�״�������������Զ��

% La = 2;                     %���߷�λ�򳤶�
% Bw = 0.886*(c/Fc)/La;       %���߷�λ�������
Bw = 0.02;
D = 4*1.128*sqrt(H0^2+L0^2)*Bw;   %�ϳɿ׾�����
La = 10;                     %��λ��ĺϳɳ���
d_min = (-1)*D;               %��ʼ����λ��
d_max = D+La;                %��������λ��
dx = 0.1;                   %������ߵĳ���

Vr = 65;                   %�����ٶ�

end

