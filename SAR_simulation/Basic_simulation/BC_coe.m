function sigma = BC_coe( th )
%BC_COE Summary of this function goes here
%�������ɢ��ϵ��
%   Detailed explanation goes here
[R,h,th_antenna,lamda,Ha0]=Parameters();
th0=pi/10;             %����ɢ��ϵ���Ĳ�������֪��Ӧ���Ƕ������������һ����

th1=th+acos((R+h-Distance(th).*cos(th))/R);
sigma=exp(-th1/th0).*cos(th1);
end

