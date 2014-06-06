function [ Fc,F0,F_sample,B,PRF,T_pulse,c,H0,L0,L_min,L_max,Bw,D,d_min,d_max,Vr ] = ParametersSystem
%PARAMETERSSYSTEM Summary of this function goes here
%   Detailed explanation goes here

Fc = 10e9;                  %�����ź�����Ƶ�ʣ���λΪ����
F_sample = 5e8;             %ϵͳ����Ƶ��
B = 4.5e8;                  %�źŴ���
F0 = Fc-B/2;                %�����ź����Ƶ��
PRF = 2000;                 %PRF
T_pulse = 1e-7;             %�������ʱ�䣬��λΪ��
c = 3e8;                    %���٣���λΪ��/��

H0 = 5000;                  %�״�ϵͳ���и߶�
L0 = 1000;                  %Ŀ������ϵ����X���꣬Ĭ��Y����Ϊ0����λΪ��
L_min = 800;                %�״����������������
L_max = 1200;               %�״�������������Զ��

La = 2;                     %���߷�λ�򳤶�
Bw = 0.886*(c/Fc)/La;       %���߷�λ�������
D = 4*1.128*sqrt(H0^2+L0^2)*Bw;   %�ϳɿ׾�����
d_min = -200;               %��ʼ����λ��
d_max = 200;                %��������λ��

Vr = 400;                   %�����ٶ�

end

