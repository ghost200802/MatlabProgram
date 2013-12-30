function  Optimize
%OPTIMIZE Summary of this function goes here
%   Detailed explanation goes here
close all;
clear all;
clc;

%%
%��ʼ������
length_thresh = 50;
angle_thresh1 = 30;
angle_thresh2 = 180;
N_turns = 1000;
N_MaxChange = 10;
%%
%���ɳ�ʼ����
[data dataconnect] = Connect(length_thresh,angle_thresh1,angle_thresh2);

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
L_mask_mother = L_mask_father;
L_mask = zeros(4,DataSize+ConnectSize);
tic
Potential_father = CaculatePotential(Lines,L_mask_father);
toc
Potential_mother = Potential_father;

h1 = waitbar(0,'���ݳ�ʼ����');
for n = 1:ConnectSize
    change = zeros(1,DataSize+ConnectSize);
    change(DataSize+n) = 1;
    L_mask(1,:) = xor(L_mask_father,change);
    Potential = CaculatePotential(Lines,L_mask(1,:));
    if(Potential<Potential_father)
        Potential_father = Potential
        L_mask_father = L_mask(1,:);
    end
    waitbar(n/ConnectSize);
end
delete(h1);
%{
h2 = waitbar(0,'��һ������');
for n = 1:(DataSize+ConnectSize)
    change = zeros(1,DataSize+ConnectSize);
    change(n) = 1;
    L_mask(1,:) = xor(L_mask_father,change);
    Potential = CaculatePotential(Lines,L_mask(1,:));
    if(Potential<Potential_father)
        Potential_father = Potential
        L_mask_father = L_mask(1,:);
    end
   waitbar(n/(DataSize+ConnectSize));
end
delete(h2);
%}

h3 = waitbar(0,'����������');
for m = N_MaxChange:-1:2
    for n = 1:N_turns
    
    %change = round(rand(1,LineSize)/parameter_temp);
    
    L_mask(1,:) = L_mask_father; 
    L_mask(1,:) = xor(L_mask(1,:),change);
    L_mask(2,:) = L_mask_mother; 
    L_mask(2,:) = xor(L_mask(2,:),change);
    L_mask(3,:) = [L_mask_father(1:DataSize),L_mask_mother(1:ConnectSize)]; 
    L_mask(3,:) = xor(L_mask(3,:),change);
    L_mask(4,:) = [L_mask_mother(1:DataSize),L_mask_father(1:ConnectSize)]; 
    L_mask(4,:) = xor(L_mask(4,:),change);
    
   
        Potential = CaculatePotential(Lines,L_mask(n,:));        
        
        if(Potential<Potential_father)               
            Potential_father = Potential;
            L_mask_father = L_mask;
        end
    end
    waitbar(n/N_turns);
end
delete(h3);


Lines = [Lines;L_mask_father];
Lines = Lines(:,Lines(8,:)==1);
%%
%���ƽ��
figure,imshow(background),hold on;
ResultSize = size(Lines,2);
for n = 1:ResultSize
    line([Lines(1,n),Lines(3,n)],[Lines(2,n),Lines(4,n)],'color','w');
end
