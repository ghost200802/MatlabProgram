function [ Fc,lambda,F_sample,B,F0,PRF,T_pulse,c,H0,th,dth,L0,R0,R_min,R_max,A_min,A_max,Vr,resolutionR,resolutionA ] = parameter
%PARAMETER Summary of this function goes here
%   Detailed explanation goes here
c = 3e8;            %���٣���λΪ��/��
Fc = 100e9;          %�����ź�����Ƶ�ʣ���λΪ����
lambda = c/Fc;      %����
F_sample = 5e9;    %ϵͳ����Ƶ�ʣ�����F_sample��<Fc��������Keystone�����ĵ����л����
B = 4.5e9;            %�źŴ���
F0 = Fc - B/2;        %�����ź����Ƶ��
PRF = 2000;         %PRF
T_pulse = 2.4e-6;             %�������ʱ�䣬��λΪ��


H0 = 5000;                   %�״�ϵͳ���и߶�
th = 30;                %�ӽ�
dth = 0.03;                %����������Ƕ�


L0 = H0*tan(th*pi/180);       %Ŀ������ϵ����X���꣬Ĭ��Y����Ϊ0����λΪ��
R0 = sqrt(L0^2+H0^2);     %б��
R_min = H0*tan((th-dth/2)*pi/180);  %��Сб��
R_max = H0*tan((th+dth/2)*pi/180);  %���б��


Bw = 0.005;                  %��λ���ӽ�
D = R0*Bw;                  %�ϳɿ׾�����
La = 10;                    %��λ��ĺϳɳ���
A_min = (-0.5)*D;           %��ʼ����λ��
A_max = 0.5*D+La;           %��������λ��

Vr = 100;                   %�����ٶ�


resolutionR = c/(2*B);
resolutionA = 0.443*lambda/Bw;

% resolutionX = 0.3;
% resolutionY = 0.3;

end

