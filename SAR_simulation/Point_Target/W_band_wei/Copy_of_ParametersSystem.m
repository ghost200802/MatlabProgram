function [ Fc,F0,F_sample,B,PRF,T_pulse,c,H0,L0,L_min,L_max,Bw,D,d_min,d_max,Vr,dx ] = ParametersSystem
%PARAMETERSSYSTEM Summary of this function goes here
%   Detailed explanation goes here

Fc = 9.375e10;                  %�����ź�����Ƶ�ʣ���λΪ����
F_sample = 700e6;             %ϵͳ����Ƶ��
B = 600e6;                  %�źŴ���
F0 = Fc-B/2;                %�����ź����Ƶ��
PRF = 1800;                 %PRF
T_pulse = 2.4e-6;             %�������ʱ�䣬��λΪ��
c = 3e8;                    %���٣���λΪ��/��

H0 = 500;                   %�״�ϵͳ���и߶�
R0 = 1000;                 %б��
L0 = sqrt(R0^2-H0^2);    %Ŀ������ϵ����X���꣬Ĭ��Y����Ϊ0����λΪ��
L_min = L0-20;              %�״����������������
L_max = L0+20;              %�״�������������Զ��

Bw = 0.17;
D = R0*Bw;                  %�ϳɿ׾�����
La = 10;                    %��λ��ĺϳɳ���
d_min = (-0.5)*D;           %��ʼ����λ��
d_max = 0.5*D+La;           %��������λ��
dx = 0.1;                   %������ߵĳ���

Vr = 65;                   %�����ٶ�

end

