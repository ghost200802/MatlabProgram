function  distance  = Distance( th )  
%Distance Summary of this function goes here
%�����������������ĳ����룬����Ϊ�н�
%Detailed explanation goes here

[R,h,th_antenna,lamda,Ha0]=Parameters();

distance=(R+h).*cos(th)-(R^2-((R+h).*sin(th)).^2).^0.5;


end

