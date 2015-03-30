function [targetRCS,targetDistance] = CaculateTarget( target,N_target,L0,Omega,t,i_pulseLength,T_sample,V0)
%CACULATETARGET Summary of this function goes here
%   Detailed explanation goes here
%��Ŀ����м��㣬�õ��������һ�л��Ǻ���ɢ��ϵ�����ڶ������״�����ϵ��
%���״�ľ��룬������������ת����ɵ����״����߷�����ٶ�
targetPosition = zeros(N_target,2); %����Ŀ�����ʱ��tʱ��λ��

targetPosition(:,1) = target(:,2)*cos(Omega*t)+target(:,3)*sin(Omega*t); %x'=x*cos(wt)+y*sin(wt)
targetPosition(:,2) = target(:,3)*cos(Omega*t)-target(:,2)*sin(Omega*t); %y'=y*cos(wt)-x*sin(wt)


targetRCS = target(:,1);  %Ŀ���ĺ���ɢ��ϵ��
targetX0 = L0+targetPosition(:,1); %��ÿ��Ŀ�겻ͬ
targetY0 = targetPosition(:,2); %��ÿ��Ŀ�겻ͬ

targetXShift = (1:i_pulseLength)*T_sample*V0;  %��ÿ��ʱ�̲�ͬ
%���о�����չ
targetX0 = targetX0*ones(1,i_pulseLength);
targetY0 = targetY0*ones(1,i_pulseLength);

targetXShift = ones(1,N_target).'*targetXShift;

targetX = targetX0 + targetXShift;

targetDistance = (targetX.^2+targetY0.^2).^0.5; %Ŀ������״�ľ���


end

