function [ F0,F_sample,B,PRF,T_pulse,T_measure,c ] = ParametersSystem
%PARAMETERSSYSTEM Summary of this function goes here
%   Detailed explanation goes here

Fc = 100e9;          %发射信号中心频率，单位为赫兹
F_sample = 5e9;    %系统采样频率（这里F_sample需<Fc，否则在Keystone函数的调用中会出错）
B = 4.5e9;            %信号带宽
F0 = Fc-B/2;        %发射信号最低频率
PRF = 2000;         %PRF
T_pulse = 1e-6;     %脉冲持续时间，单位为秒
T_measure = 0.5;    %测量的总时间,单位为秒
c = 3e8;            %光速，单位为米/秒

end

