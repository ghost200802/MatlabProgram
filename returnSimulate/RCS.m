function [ RCS,terrainRange,terrainWide,terrainLength,XScale,YScale ] = RCS
%RCS Summary of this function goes here
%   Detailed explanation goes here
close all
clear all
%%
%parameters
[ ~,~,~,~,~,~,height,distance,resolutionX,resolutionY ] = parameter();
terrainXScale = 0.1;
terrainYScale = 0.08;
terrainZScale = 0.5;

resolutionCellX = floor(resolutionX/terrainXScale);
resolutionCellY = floor(resolutionY/terrainYScale);
XScale = resolutionCellX*terrainXScale;
YScale = resolutionCellY*terrainYScale;

needDisplay = 0;
%%
%RCS计算
terrain = terrainSimulate();
[ terrainColum , terrainRow ] = size(terrain);

terrainWide = terrainColum*terrainXScale;
terrainLength = terrainRow*terrainYScale;

RCSColum = floor(terrainColum/resolutionCellX);
RCSRow = floor(terrainRow/resolutionCellY);

%RCS = zeros(RCSColum,RCSRow);
terrainCellHeight = zeros(RCSColum,RCSRow);
%terrainRange = zeros(RCSColum,RCSRow);
terrainNotBlocked = zeros(RCSColum,RCSRow);
terrainIncidenceAngle = zeros(RCSColum,RCSRow);
terrainReflexAngle = zeros(RCSColum,RCSRow);

%%
%计算每个分辨单元的高度,斜距,单元内的高度差
for m = 1:RCSColum
    for n = 1:RCSRow
        terrainCellHeight(m,n) = mean(mean(terrain((m-1)*resolutionCellX+1:m*resolutionCellX,(n-1)*resolutionCellY+1:n*resolutionCellY)));
        terrainHeightChangeX1(m,n) = terrain(m*resolutionCellX,n) - terrain((m-1)*resolutionCellX+1,n);
        terrainHeightChangeX2(m,n) = terrain(m*resolutionCellX,n+1) - terrain((m-1)*resolutionCellX+1,n+1);
        terrainHeightChangeY1(m,n) = terrain(m,n*resolutionCellY) - terrain(m,(n-1)*resolutionCellY+1);
        terrainHeightChangeY2(m,n) = terrain(m+1,n*resolutionCellY) - terrain(m+1,(n-1)*resolutionCellY+1);
    end
end
terrainCellHeight = terrainCellHeight*terrainZScale;

terrainRange = ((distance+(terrainXScale*resolutionCellX:(terrainXScale*resolutionCellX):(RCSColum*terrainXScale*resolutionCellX)).'*ones(1,RCSRow)).^2 + (height-terrainCellHeight).^2).^0.5;

%%
%计算每个分辨单元是否被遮挡
terrainLookAngle = atan((distance+(terrainXScale*resolutionCellX:(terrainXScale*resolutionCellX):(RCSColum*terrainXScale*resolutionCellX)).'*ones(1,RCSRow))./(height-terrainCellHeight));

terrainMaxLookAngle = zeros(1,RCSRow);

for m = 1:RCSColum
    terrainMaxLookAngle = max([terrainMaxLookAngle;terrainLookAngle(m,:)]);
    terrainNotBlocked(m,:) = (terrainLookAngle(m,:)>=terrainMaxLookAngle);
end
%%
%计算每个分辨单元的法线角度及与照射波束的夹角
% 
% vectorIncidence = [-1,0,1];
% vectorReflex = [0,0,1];
% 
% for m = 1:RCSColum
%     for n = 1:RCSRow
%         vectorA = [XScale,0,terrainHeightChangeX1(m,n)];
%         vectorB = [0,YScale,terrainHeightChangeY1(m,n)];
%         vectorC = [-XScale,0,terrainHeightChangeX2(m,n)];
%         vectorD = [0,-YScale,terrainHeightChangeY2(m,n)];
%         vector1 = cross(vectorA,vectorB);
%         vector1 = vector1/sqrt(dot(vector1,vector1));
%         vector2 = cross(vectorC,vectorD);
%         vector2 = vector2/sqrt(dot(vector2,vector2));
%         vectorTerrain = vector1+vector2;
%         terrainIncidenceAngle(m,n) = acosd(dot(vectorTerrain,vectorIncidence)/sqrt(dot(vectorTerrain,vectorTerrain))/sqrt(dot(vectorIncidence,vectorIncidence)));
%         terrainReflexAngle(m,n) = acosd(dot(vectorTerrain,vectorReflex)/sqrt(dot(vectorTerrain,vectorTerrain))/sqrt(dot(vectorIncidence,vectorIncidence)));
%     end
% end
% figure
% mesh(terrainIncidenceAngle)
%         
        


%RCS = log(abs(terrainCellHeight/max(max(terrainCellHeight)).*terrainNotBlocked)+1)+1;
RCS = terrainNotBlocked;
%%
%展示结果
if (needDisplay)
    figure
    mesh(terrainCellHeight)
    figure
    mesh(terrainRange)
    figure
    mesh(terrainLookAngle)
    figure
    imagesc(terrainNotBlocked),colormap('gray')
end
end

