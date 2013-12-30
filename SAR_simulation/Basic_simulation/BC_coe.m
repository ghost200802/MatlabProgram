function sigma = BC_coe( th )
%BC_COE Summary of this function goes here
%计算后向散射系数
%   Detailed explanation goes here
[R,h,th_antenna,lamda,Ha0]=Parameters();
th0=pi/10;             %后向散射系数的参数（不知道应该是多少随便设置了一个）

th1=th+acos((R+h-Distance(th).*cos(th))/R);
sigma=exp(-th1/th0).*cos(th1);
end

