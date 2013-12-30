function  Optimize
%OPTIMIZE Summary of this function goes here
%   Detailed explanation goes here
close all;
clear all;
clc;

%%
%初始化参数
length_thresh = 40;
angle_thresh = 30;
T = 1000;
N_MaxChange = 3;
%%
%生成初始数据
[data dataconnect] = Connect(length_thresh,angle_thresh);

DataSize = size(data,2);
ConnectSize = size(dataconnect,2);

LineSize = DataSize+ConnectSize;
Lines = [data,dataconnect];
Lines(7,:) = Lines(7,:)/max(Lines(7,:)); 
%Nodes中的数据数据结构如下：
%第1排：第1个点的X坐标
%第2排：第1个点的Y坐标
%第3排：第2个点的X坐标
%第4排：第2个点的Y坐标
%第5排：直线的可信概率
%第6排：直线的角度（以X正方向为0，范围为0-179取整）
%第7排：直线的归一化长度
%%
%绘制初始连结图

background = zeros(500,500);
figure,imshow(background),hold on;
for n = 1:DataSize
    line([data(1,n),data(3,n)],[data(2,n),data(4,n)],'color','w');
end
figure,imshow(background),hold on;
for n = 1:DataSize
    line([data(1,n),data(3,n)],[data(2,n),data(4,n)],'color','w','LineWidth',2);
end
for n = 1:ConnectSize
    line([dataconnect(1,n),dataconnect(3,n)],[dataconnect(2,n),dataconnect(4,n)],'color','w');
end

%%

L_mask_father = [ones(1,DataSize),zeros(1,ConnectSize)];
L_mask = zeros(4,DataSize+ConnectSize);
tic
Potential_father = CaculatePotential(Lines,L_mask_father);
Potential_min = Potential_father;
toc


h1 = waitbar(0,'数据初始化中');
for n = 1:ConnectSize
    change = zeros(1,DataSize+ConnectSize);
    change(DataSize+n) = 1;
    L_mask = xor(L_mask_father,change);
    Potential = CaculatePotential(Lines,L_mask);
    if(Potential<Potential_father)
        Potential_father = Potential
        L_mask_father = L_mask;
    end
    waitbar(n/ConnectSize);
end
delete(h1);

Potential_min = Potential;
L_mask_min = L_mask;

%{
h2 = waitbar(0,'搜索');
while(T>500)
    change = zeros(1,DataSize+ConnectSize);
    change(round(rand*(LineSize-1))+1) = 1;
    L_mask = xor(L_mask_father,change);
    Potential = CaculatePotential(Lines,L_mask);
    if(Potential<Potential_father)
        Potential_father = Potential
        L_mask_father = L_mask;
        T = T-1
    else
        if(rand<exp((Potential_father-Potential))/T)
            Potential_father = Potential
            L_mask_father = L_mask;      
            T = T-1
        end
    end
    
    if(Potential<Potential_min)
        Potential_min = Potential
        L_mask_min = L_mask;
    end
   waitbar(n/T);
end
delete(h2);
%}

h3 = waitbar(0,'继续搜索');
for n = 1:(DataSize+ConnectSize)
    change = zeros(1,DataSize+ConnectSize);
    change(n) = 1;
    L_mask = xor(L_mask_min,change);
    Potential = CaculatePotential(Lines,L_mask);
    if(Potential<Potential_min)
        Potential_min = Potential
        L_mask_min = L_mask;
    end
   waitbar(n/(DataSize+ConnectSize));
end
delete(h3);




Lines = [Lines;L_mask_min];
Lines = Lines(:,Lines(8,:)==1);
save('Lines.mat','Lines');
%%
%绘制结果
figure,imshow(background),hold on;
ResultSize = size(Lines,2);
for n = 1:ResultSize
    line([Lines(1,n),Lines(3,n)],[Lines(2,n),Lines(4,n)],'color','w');
end
