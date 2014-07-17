function [ Fc,F0,F_sample,B,PRF,T_pulse,c,H0,L0,L_min,L_max,Bw,D,d_min,d_max,Vr,dx ] = ParametersSystem
%PARAMETERSSYSTEM Summary of this function goes here
%   Detailed explanation goes here

Fc = 9.375e10;                  %发射信号中心频率，单位为赫兹
F_sample = 700e6;             %系统采样频率
B = 600e6;                  %信号带宽
F0 = Fc-B/2;                %发射信号最低频率
PRF = 1800;                 %PRF
T_pulse = 2.4e-6;             %脉冲持续时间，单位为秒
c = 3e8;                    %光速，单位为米/秒

H0 = 500;                   %雷达系统飞行高度
R0 = 1000;                 %斜距
L0 = sqrt(R0^2-H0^2);    %目标坐标系中心X坐标，默认Y坐标为0，单位为米
L_min = L0-20;              %雷达照射条带的最近点
L_max = L0+20;              %雷达照射条带的最远点

Bw = 0.17;
D = R0*Bw;                  %合成孔径长度
La = 10;                    %方位向的合成长度
d_min = (-0.5)*D;           %起始照射位置
d_max = 0.5*D+La;           %结束照射位置
dx = 0.1;                   %干涉基线的长度

Vr = 65;                   %飞行速度

end

