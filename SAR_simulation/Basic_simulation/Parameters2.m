function [ Vs,LF,Laz,T,K,c,tr,Pt,La0,ante_eff ] = Parameters2
%PARAMETERS2 Summary of this function goes here
%NESZ相关参数
%   Detailed explanation goes here
Vs=7590;            %平台运动速度
LF=10^0.3;          %损耗
Laz=10^0.17;
T=290;              %温度 
K=1.38e-23;         %波尔兹漫常数
c=3e8;  
tr=120e-6;          %脉冲间隔
Pt=20e3;             %发射信号功率
La0=0.9;            %天线方位向长度
ante_eff=0.85 ;  %天线效率

end

