function [ L0,L_range,Omega0,dOmega,ddOmega,dddOmega,V0,a] = ParametersTarget
%PARAMETERS Summary of this function goes here
%   Detailed explanation goes here
%本函数是仿真参数列表

L0 = 10000;        %目标坐标系中心X坐标，默认Y坐标为0，单位为米
L_range = 20;       %由于计算量的限制，这里是在目标周围的接收回波区域范围，单位为米
Omega0 = 1e-1;       %平台转动角速度，单位为弧度
dOmega = 0;
ddOmega = 0;
dddOmega = 0;
% dOmega = 0.1*Omega0;      %平台转动角速度变化率
% ddOmega = -0.0001;
% dddOmega = 0.0000004;
% V0 = 1;             %目标初速度
% a = 6;              %目标加速度
V0 = 4;             %目标初速度
a = -4;              %目标加速度

end


