function  degree  = Degree( s )  
%Distance Summary of this function goes here
%函数计算卫星与地面某点夹角，参数为距离
%Detailed explanation goes here

[R,h,th_antenna,lamda,Ha0]=Parameters();

degree=acos(((R+h)^2+s.^2-R^2)./(2*(R+h).*s));

end

