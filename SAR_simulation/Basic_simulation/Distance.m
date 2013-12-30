function  distance  = Distance( th )  
%Distance Summary of this function goes here
%函数计算卫星与地面某点距离，参数为夹角
%Detailed explanation goes here

[R,h,th_antenna,lamda,Ha0]=Parameters();

distance=(R+h).*cos(th)-(R^2-((R+h).*sin(th)).^2).^0.5;


end

