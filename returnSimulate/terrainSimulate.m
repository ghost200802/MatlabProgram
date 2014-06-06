function [ terrain ] = terrainSimulate
%TERRAINSIMULATE Summary of this function goes here
%   Detailed explanation goes here
%%
%参数
H = 0.7;
fluctuate = 2;
step = 6;
siglePointSmooth = 1;

needDisplay = 1;

if (H>1)
    H = 1;
end

if (step > 10)
   step = 10;
end
%%
%计算过程
terrain = inputTerrain();
fluctuate = fluctuate*(1-2^(2*H-2))^0.5;
for currentStep = 1:step
    [M,N] = size(terrain);
    %计算每个中心点的高度
    fluctuate = fluctuate/2^(H/2);
    detH = fluctuate*randn([2*M-1,2*N-1]);    
    terrainMid1 = zeros(M-1,N);
    terrainMid = zeros(M-1,N-1);
    for i = 1:M-1
        terrainMid1(i,:) = terrain(i,:) + terrain(i+1,:);
    end
    for i = 1:N-1
        terrainMid(:,i) = terrainMid1(:,i) + terrainMid1(:,i+1);
    end
    terrainMid = terrainMid/4;
    %拓展terrain矩阵
    terrainBackup = terrain;
    terrain = zeros(2*M-1,N);
    terrain(1:2:end,:) = terrainBackup(1:end,:);
    terrainBackup = terrain;
    terrain = zeros(2*M-1,2*N-1);
    terrain(:,1:2:end) = terrainBackup(:,1:end);
    %加入中心节点
    terrain(2:2:end,2:2:end) = terrainMid + detH(2:2:end,2:2:end);
    %计算并加入边线节点的高度
    fluctuate = fluctuate/2^(H/2);
    detH = fluctuate*randn([2*M-1,2*N-1]); 
    terrainExpand = zeros(2*M+1,2*N+1);
    terrainExpand(2:2*M,2:2*N) = terrain;
    terrain(1:2:end,2:2:end) = (terrainExpand(1:2:end-2,3:2:end-2) + terrainExpand(3:2:end,3:2:end-2) + terrainExpand(2:2:end,2:2:end-2) + terrainExpand(2:2:end,4:2:end))/4 + detH(1:2:end,2:2:end);
    terrain(2:2:end,1:2:end) = (terrainExpand(3:2:end-2,1:2:end-2) + terrainExpand(3:2:end-2,3:2:end) + terrainExpand(2:2:end-2,2:2:end) + terrainExpand(4:2:end,2:2:end))/4 + detH(2:2:end,1:2:end);
    %平滑孤立的控制点
    if (currentStep == 1)
        for m = 3:2:2*M-3
            for n = 3:2:2*N-3
                if ((terrain(m,n) == max(max(terrain(m-1:m+1,n-1:n+1)))) || (terrain(m,n) == min(min(terrain(m-1:m+1,n-1:n+1)))))
                    terrain(m,n) = terrain(m,n)*(1-siglePointSmooth) + (sum(sum(terrain(m-1:m+1,n-1:n+1))) - terrain(m,n))/8*siglePointSmooth + detH(m,n);
                else
                    terrain(m,n) = (sum(sum(terrain(m-1:m+1,n-1:n+1))) - terrain(m,n))/8 + detH(m,n);
                end
            end
        end
    end
end

%%
%展示结果
if (needDisplay)
    figure
    mesh(terrain)
end
end

