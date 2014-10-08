function [ Fc,lambda,F_sample,B,F0,PRF,T_pulse,c,H0,th,dth,L0,R0,R_min,R_max,A_min,A_max,Vr,resolutionR,resolutionA ] = parameter
%PARAMETER Summary of this function goes here
%   Detailed explanation goes here
c = 3e8;            %光速，单位为米/秒
Fc = 100e9;          %发射信号中心频率，单位为赫兹
lambda = c/Fc;      %波长
F_sample = 5e9;    %系统采样频率（这里F_sample需<Fc，否则在Keystone函数的调用中会出错）
B = 4.5e9;            %信号带宽
F0 = Fc - B/2;        %发射信号最低频率
PRF = 2000;         %PRF
T_pulse = 2.4e-6;             %脉冲持续时间，单位为秒


H0 = 5000;                   %雷达系统飞行高度
th = 30;                %视角
dth = 0.03;                %距离向照射角度


L0 = H0*tan(th*pi/180);       %目标坐标系中心X坐标，默认Y坐标为0，单位为米
R0 = sqrt(L0^2+H0^2);     %斜距
R_min = H0*tan((th-dth/2)*pi/180);  %最小斜距
R_max = H0*tan((th+dth/2)*pi/180);  %最大斜距


Bw = 0.005;                  %方位向视角
D = R0*Bw;                  %合成孔径长度
La = 10;                    %方位向的合成长度
A_min = (-0.5)*D;           %起始照射位置
A_max = 0.5*D+La;           %结束照射位置

Vr = 100;                   %飞行速度


resolutionR = c/(2*B);
resolutionA = 0.443*lambda/Bw;

% resolutionX = 0.3;
% resolutionY = 0.3;

end

