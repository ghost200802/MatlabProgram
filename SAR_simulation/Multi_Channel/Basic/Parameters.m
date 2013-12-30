function [ Vs,F0,Lamda,H,Br,La,N,daz,c ] = Parameters
%PARAMETERS Summary of this function goes here
%系统的各参数
%   Detailed explanation goes here

Vs=7482.7;              %卫星速度
F0=9.65e9;              %载频
H=675e3;                %轨道高度
Br=120e6;               %系统带宽（没用到）
La=4;                   %天线方位向长度（没用到）
N=3;                    %并列天线数量
daz=3.337;              %天线想为中心距离
c=3e8;                  

Lamda=c/F0;

end

