function  Optimize
%OPTIMIZE Summary of this function goes here
%   Detailed explanation goes here
close all;
clear all;
clc;

%%
%��ʼ������
length_thresh = 40;
angle_thresh = 30;
T = 1000;
N_MaxChange = 3;
%%
%���ɳ�ʼ����
[data dataconnect] = Connect(length_thresh,angle_thresh);

DataSize = size(data,2);
ConnectSize = size(dataconnect,2);

LineSize = DataSize+ConnectSize;
Lines = [data,dataconnect];
Lines(7,:) = Lines(7,:)/max(Lines(7,:)); 
%Nodes�е��������ݽṹ���£�
%��1�ţ���1�����X����
%��2�ţ���1�����Y����
%��3�ţ���2�����X����
%��4�ţ���2�����Y����
%��5�ţ�ֱ�ߵĿ��Ÿ���
%��6�ţ�ֱ�ߵĽǶȣ���X������Ϊ0����ΧΪ0-179ȡ����
%��7�ţ�ֱ�ߵĹ�һ������
%%
%���Ƴ�ʼ����ͼ

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


h1 = waitbar(0,'���ݳ�ʼ����');
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
h2 = waitbar(0,'����');
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

h3 = waitbar(0,'��������');
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
%���ƽ��
figure,imshow(background),hold on;
ResultSize = size(Lines,2);
for n = 1:ResultSize
    line([Lines(1,n),Lines(3,n)],[Lines(2,n),Lines(4,n)],'color','w');
end
