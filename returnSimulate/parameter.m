function [ Fc,F_sample,B,F0,PRF,c,height,distance,resolutionX,resolutionY ] = parameter
%PARAMETER Summary of this function goes here
%   Detailed explanation goes here

Fc = 100e9;          %�����ź�����Ƶ�ʣ���λΪ����
F_sample = 5e9;    %ϵͳ����Ƶ�ʣ�����F_sample��<Fc��������Keystone�����ĵ����л����
B = 4.5e9;            %�źŴ���
F0 = Fc - B/2;        %�����ź����Ƶ��
PRF = 2000;         %PRF
c = 3e8;            %���٣���λΪ��/��

resolutionX = 0.3;
resolutionY = 0.3;

height = 5e3;
distance = 2e3;



th = 30;


end

