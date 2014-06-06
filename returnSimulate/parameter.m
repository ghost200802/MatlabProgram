function [ Fc,F_sample,B,F0,PRF,c,height,distance,resolutionX,resolutionY ] = parameter
%PARAMETER Summary of this function goes here
%   Detailed explanation goes here

Fc = 100e9;          %发射信号中心频率，单位为赫兹
F_sample = 5e9;    %系统采样频率（这里F_sample需<Fc，否则在Keystone函数的调用中会出错）
B = 4.5e9;            %信号带宽
F0 = Fc - B/2;        %发射信号最低频率
PRF = 2000;         %PRF
c = 3e8;            %光速，单位为米/秒

resolutionX = 0.3;
resolutionY = 0.3;

height = 5e3;
distance = 2e3;



th = 30;


end

