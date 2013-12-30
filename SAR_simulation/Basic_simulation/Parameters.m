function [ R,h,th_antenna,lamda,Ha0 ] = Parameters
%PARAMETERS Summary of this function goes here
%系统的各参数
%--------------------------------------
%       文件结构
%Parameters 设置系统参数
%Degree Distance 实现距离与角度的互相转换
%G_antenna 天线方向图
%BC_coe 计算后向散射系数
%Equ_Ha 等效天线长度
%Point_RASR 计算某一点的RASR
%Line_RASR 计算某一范围的RASR
%Plot_RASR 读取数据并画图
%--------------------------------------
%   Detailed explanation goes here

R=6371e3;               %地球半径
h=675e3;                %轨道高度
th_antenna=(33/180)*pi; %天线安装倾角  
lamda=3e8/9.6e9;            %雷达波长
Ha0=2.923;              %天线距离向尺寸

end

