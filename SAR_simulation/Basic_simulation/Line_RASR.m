function [S_RASR,th]=Line_RASR(th1,th2,PRF)
%P_RETUREN Summary of this function goes here
%����ĳһ������RASR
%Detailed explanation goes here
[R,h,th_antenna,lamda,Ha0]=Parameters();

Ha=Equ_Ha(th1,th2);
dth=0.001;                          %ģ�⾫��

th1=round(th1/dth)*dth;             %����Ԥ����
th2=round(th2/dth)*dth;

th=th1:dth:th2;
th_middle=(th2+th1)/2;


for i=1:round(((th2-th1)/dth)+1)
    S_RASR(i)=Point_RASR(th(i),th_middle,Ha,PRF);
end
    





