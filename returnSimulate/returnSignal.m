function [ returnSignal ] = returnSignal
%RETURNSIGNAL Summary of this function goes here
%��ʱ�������״ﲨ�������䵽�Ͻ��ĵط��Լ���Զ�ĵط��״﹦���ܶȵı仯
%   Detailed explanation goes here
close all
clear all
%%
%����
[ ~,~,~,~,~,~,height,distance,resolutionX,resolutionY ] = parameter();
%%
%
[returnSignal,terrainRange,terrainWide,terrainLength,XScale,YScale] = RCS();


returnSignal = slantRangeChange(returnSignal,terrainRange,height,distance,terrainWide,XScale,resolutionX);

%%
%��ʾ
figure
imagesc(returnSignal),colormap('gray')
end

