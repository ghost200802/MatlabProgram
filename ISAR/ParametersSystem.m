function [ F0,F_sample,B,PRF,T_pulse,T_measure,c ] = ParametersSystem
%PARAMETERSSYSTEM Summary of this function goes here
%   Detailed explanation goes here

Fc = 100e9;          %�����ź�����Ƶ�ʣ���λΪ����
F_sample = 5e9;    %ϵͳ����Ƶ�ʣ�����F_sample��<Fc��������Keystone�����ĵ����л����
B = 4.5e9;            %�źŴ���
F0 = Fc-B/2;        %�����ź����Ƶ��
PRF = 2000;         %PRF
T_pulse = 1e-6;     %�������ʱ�䣬��λΪ��
T_measure = 0.5;    %��������ʱ��,��λΪ��
c = 3e8;            %���٣���λΪ��/��

end

