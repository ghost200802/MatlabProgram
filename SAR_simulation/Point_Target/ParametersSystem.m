function [ Fc,F0,F_sample,B,PRF,T_pulse,c,H0,L0,L_min,L_max,Bw,D,d_min,d_max,Vr ] = ParametersSystem
%PARAMETERSSYSTEM Summary of this function goes here
%   Detailed explanation goes here

Fc = 10e9;                  %发射信号中心频率，单位为赫兹
F_sample = 5e8;             %系统采样频率
B = 4.5e8;                  %信号带宽
F0 = Fc-B/2;                %发射信号最低频率
PRF = 2000;                 %PRF
T_pulse = 1e-7;             %脉冲持续时间，单位为秒
c = 3e8;                    %光速，单位为米/秒

H0 = 5000;                  %雷达系统飞行高度
L0 = 1000;                  %目标坐标系中心X坐标，默认Y坐标为0，单位为米
L_min = 800;                %雷达照射条带的最近点
L_max = 1200;               %雷达照射条带的最远点

La = 2;                     %天线方位向长度
Bw = 0.886*(c/Fc)/La;       %天线方位向波束宽度
D = 4*1.128*sqrt(H0^2+L0^2)*Bw;   %合成孔径长度
d_min = -200;               %起始照射位置
d_max = 200;                %结束照射位置

Vr = 400;                   %飞行速度

end

