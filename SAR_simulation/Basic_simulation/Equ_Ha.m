function Ha = Equ_Ha( th1,th2 )
%EQU_HA Summary of this function goes here
%计算雷达距离方向等效长度
%   Detailed explanation goes here

[R,h,th_antenna,lamda,Ha0]=Parameters();

Ha=0.886*lamda/(max(th1,th2)-min(th1,th2));

Ha=min(Ha,Ha0);

end

