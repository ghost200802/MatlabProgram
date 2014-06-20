function targetCondition = CaculateTarget(target,N_target,H0,L0,D,d,Bw,t,dx)
%CACULATETARGET Summary of this function goes here
%   Detailed explanation goes here
%��Ŀ����м��㣬�õ��������һ�л��Ǻ���ɢ��ϵ�����ڶ������״�����ϵ��
%���״�ľ��룬������������ת����ɵ����״����߷�����ٶ�
targetPosition = zeros(N_target,2); %����Ŀ�����ʱ��tʱ��λ��


targetPosition(:,1) = sqrt((L0+target(:,2)+t*target(:,4)).^2 + H0^2);
targetPosition(:,2) = target(:,3)+target(:,5)-d;

    
%targetPosition(:,1) = target(:,2)*cos(Omega*t)+target(:,3)*sin(Omega*t); %x'=x*cos(wt)+y*sin(wt)
%targetPosition(:,2) = target(:,3)*cos(Omega*t)-target(:,2)*sin(Omega*t); %y'=y*cos(wt)-x*sin(wt)

targetCondition = zeros(N_target,3);

targetCondition(:,2) = sqrt((targetPosition(:,1)).^2+(targetPosition(:,2).^2))+sqrt((targetPosition(:,1)).^2+((targetPosition(:,2)+dx).^2)); %Ŀ������״��˫�̾���
targetCondition(:,3) = (D>= abs(target(:,3)-d)); %Ŀ���Ƿ��ڳ���Χ��

th = targetPosition(:,2)./targetCondition(:,2);
Pa = sinc(0.886*th/Bw);
targetCondition(:,1) = target(:,1).*Pa.^2;  %Ŀ���ĵ�Ч����ɢ��ϵ��
end

