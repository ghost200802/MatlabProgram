function [ L0,L_range,Omega0,dOmega,ddOmega,dddOmega,V0,a] = ParametersTarget
%PARAMETERS Summary of this function goes here
%   Detailed explanation goes here
%�������Ƿ�������б�

L0 = 10000;        %Ŀ������ϵ����X���꣬Ĭ��Y����Ϊ0����λΪ��
L_range = 20;       %���ڼ����������ƣ���������Ŀ����Χ�Ľ��ջز�����Χ����λΪ��
Omega0 = 1e-1;       %ƽ̨ת�����ٶȣ���λΪ����
dOmega = 0;
ddOmega = 0;
dddOmega = 0;
% dOmega = 0.1*Omega0;      %ƽ̨ת�����ٶȱ仯��
% ddOmega = -0.0001;
% dddOmega = 0.0000004;
% V0 = 1;             %Ŀ����ٶ�
% a = 6;              %Ŀ����ٶ�
V0 = 4;             %Ŀ����ٶ�
a = -4;              %Ŀ����ٶ�

end


