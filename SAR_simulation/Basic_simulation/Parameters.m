function [ R,h,th_antenna,lamda,Ha0 ] = Parameters
%PARAMETERS Summary of this function goes here
%ϵͳ�ĸ�����
%--------------------------------------
%       �ļ��ṹ
%Parameters ����ϵͳ����
%Degree Distance ʵ�־�����ǶȵĻ���ת��
%G_antenna ���߷���ͼ
%BC_coe �������ɢ��ϵ��
%Equ_Ha ��Ч���߳���
%Point_RASR ����ĳһ���RASR
%Line_RASR ����ĳһ��Χ��RASR
%Plot_RASR ��ȡ���ݲ���ͼ
%--------------------------------------
%   Detailed explanation goes here

R=6371e3;               %����뾶
h=675e3;                %����߶�
th_antenna=(33/180)*pi; %���߰�װ���  
lamda=3e8/9.6e9;            %�״ﲨ��
Ha0=2.923;              %���߾�����ߴ�

end

