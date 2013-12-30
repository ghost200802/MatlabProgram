function NESZ=Caculate_NESZ(th,PRF,Br,Ha)
%Point_RASR Summary of this function goes here
%计算某一点的NESZ
%Detailed explanation goes here

[R,h,th_antenna,lamda,Ha0]=Parameters();
[Vs,LF,Laz,T,K,c,tr,Pt,La0,ante_eff] = Parameters2();

A=Ha*La0 ;         %天线面积
fc=c/lamda;
G=4*pi*A/(lamda^2); %天线增益

R0=Distance(th);
NESZ=256*(pi^3)*(R0.^3).*sin(th)*Vs*Br*K*T*LF*Laz/(Pt*(G^2)*lamda^3*tr*PRF*c);
NESZ=10.*log(NESZ)/log(10);