function [ returnSignal ] = slantRangeChange( flatReturnSignal,terrainRange,height,distance,terrainWide,XScale,resolutionX )
%SLANTRANGECHANGE Summary of this function goes here
%   Detailed explanation goes here
%%
%�����ʼ������
nearestPoint = (height^2 + distance^2)^0.5;
farthestPoint = (height^2 + (distance + terrainWide)^2)^0.5;
[flatColum,flatRow] = size(flatReturnSignal);

slantColum = ceil((farthestPoint-nearestPoint)/resolutionX)+1;
slantRow = flatRow;

returnSignal = zeros(slantColum,slantRow);
%%
%���ݹ���������
%��С��nearestPoint�ĵ�����
terrainNotInRange = terrainRange < nearestPoint;
flatReturnSignal(terrainNotInRange) = 0;
terrainRange(terrainNotInRange) = nearestPoint;
%������farthestPoint�ĵ�����
terrainNotInRange = terrainRange > farthestPoint;
flatReturnSignal(terrainNotInRange) = 0;
terrainRange(terrainNotInRange) = farthestPoint;
%%
terrainRange = round((terrainRange - nearestPoint)/resolutionX) + 1;
for m = 1:flatColum
    for n = 1:flatRow
        slantRange = terrainRange(m,n);
        returnSignal(slantRange,n) = returnSignal(slantRange,n) + flatReturnSignal(m,n);
    end
end

end

