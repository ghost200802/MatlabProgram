function [ returnSignal ] = returnSignal
%RETURNSIGNAL Summary of this function goes here
%暂时忽略了雷达波束在照射到较近的地方以及较远的地方雷达功率密度的变化
%   Detailed explanation goes here
close all
clear all
%%
%参数
[ ~,~,~,~,~,~,height,distance,resolutionX,resolutionY ] = parameter();
%%
%
[returnSignal,terrainRange,terrainWide,terrainLength,XScale,YScale] = RCS();


returnSignal = slantRangeChange(returnSignal,terrainRange,height,distance,terrainWide,XScale,resolutionX);

%%
%显示
figure
imagesc(returnSignal),colormap('gray')
end

