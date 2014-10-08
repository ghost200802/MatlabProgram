function [ Fc,F0,F_sample,B,PRF,T_pulse,c,H0,L0,L_min,L_max,Bw,D,d_min,d_max,Vr,dx ] = ParametersSystem
%PARAMETERSSYSTEM Summary of this function goes here
%   Detailed explanation goes here
c = 3e8;                    %光速，单位为米/秒
lambda = 0.0085;
Fc = c/lambda;                  %发射信号中心频率，单位为赫兹
F_sample = 1300e6;             %系统采样频率
B = 1000e6;                  %信号带宽
F0 = Fc-B/2;                %发射信号最低频率
PRF = 8000;                 %PRF
T_pulse = 2.4e-6;             %脉冲持续时间，单位为秒


% H0 = 500;                   %雷达系统飞行高度
% R0 = H0*tan(65*pi/180);     %斜距
% L0 = sqrt(R0^2-H0^2);       %目标坐标系中心X坐标，默认Y坐标为0，单位为米
% L_min = H0*tan(58*pi/180);  %最小斜距
% L_max = H0*tan(72*pi/180);  %最大斜距

H0 = 500;                   %雷达系统飞行高度

L0 = H0*tan(60*pi/180);       %目标坐标系中心X坐标，默认Y坐标为0，单位为米
R0 = sqrt(L0^2+H0^2);     %斜距
L_min = H0*tan(59*pi/180);  %最小斜距
L_max = H0*tan(61*pi/180);  %最大斜距


Bw = 0.03;
D = R0*Bw;                  %合成孔径长度
La = 10;                    %方位向的合成长度
d_min = (-1)*D;           %起始照射位置
d_max = D+La;           %结束照射位置
dx = 0.1;                   %干涉基线的长度

%59.5-69.5
Vr = 65;                   %飞行速度

end

