function [ Potential ] = CaculatePotential( Lines,L_mask )
%CACULATEPOTENTIAL Summary of this function goes here
%   Detailed explanation goes here
%%
%数据初始化
t1 = 0.2;
t2 = 0.3;
Ke = 0.21;
Kl = 0.12;
Kc = 0.8;
Ki = 0.8;

LineSize = size(Lines,2);
Nodes = FindNodes(Lines,L_mask,LineSize);
NodeSize = size(Nodes,2);
%%
%计算势能1
Lines0 = [Lines;L_mask];
Lines0 = Lines0(:,Lines0(8,:)==0);
Lines1 = Lines0(:,Lines0(5,:)>=t1);
Lines1 = Lines1(:,Lines1(5,:)<t2);
Lines2 = Lines0(:,Lines0(5,:)>=t2);
Potential1 = sum(Lines1(7,:).*(Lines1(5,:)-t1)/(t2-t1))+sum(Lines2(7,:));
%%
%计算势能2
Potential2_1 = 0;
Potential2_2 = 0;
Potential2_3 = 0;
Potential2_4 = 0;
Potential2_5 = 0;
%对Nodes提取出节点中包含1,2,3,4，更多直线的节点
flag_nodes_1 = 1;
flag_nodes_2 = 1;
flag_nodes_3 = 1;
flag_nodes_4 = 1;
flag_nodes_others = 1;
if(NodeSize>=5)
    Nodes_others = Nodes(Nodes(:,5)>0,:);
    Nodes = Nodes(Nodes(:,5)==0,1:4);
else
    flag_nodes_others = 0;
end
if(NodeSize>=4)
    Nodes_4 = Nodes(Nodes(:,4)>0,:);
    Nodes = Nodes(Nodes(:,4)==0,1:3);
else
    flag_nodes_4 = 0;
end
if(NodeSize>=3)
    Nodes_3 = Nodes(Nodes(:,3)>0,:);
    Nodes = Nodes(Nodes(:,3)==0,1:2);
else
    flag_nodes_3 = 0;
end
if(NodeSize>=2)
    Nodes_2 = Nodes(Nodes(:,2)>0,:);
    Nodes = Nodes(Nodes(:,2)==0,1:1);
else
    flag_nodes_2 = 0;
end
if(NodeSize>=1)
    Nodes_1 = Nodes;
else
    flag_nodes_1 = 0;
end
%对以上的每一种情况计算相应的Potential2并累加
if(flag_nodes_1)
    for m = 1:size(Nodes_1,1)
        Potential2_1 = Potential2_1+Ke-Kl*Lines(7,Nodes_1(m,1));
    end
end

if(flag_nodes_2)    
    for m = 1:size(Nodes_2,1)
        [angle] = NodeCaculateAngle([Lines(1:4,Nodes_2(m,1)),Lines(1:4,Nodes_2(m,2))],2);
        angle1 = angle(1);
        angle2 = angle(2);
        angle12 = min(abs(angle1-angle2),(2*pi-abs(angle1-angle2)));
        %th = abs(Lines(6,Nodes_2(m,1))-Lines(6,Nodes_2(m,2)))*pi/180;
        Potential2_2 = Potential2_2+Kc*sin(angle12)-Kl*(Lines(7,Nodes_2(m,1))+Lines(7,Nodes_2(m,2)));
    end
end

if(flag_nodes_3)
    for m = 1:size(Nodes_3,1)
        [angle] = NodeCaculateAngle([Lines(1:4,Nodes_3(m,1)),Lines(1:4,Nodes_3(m,2)),Lines(1:4,Nodes_3(m,3))],3);
        angle1 = angle(1);
        angle2 = angle(2);
        angle3 = angle(3);
        angle12 = min(abs(angle1-angle2),(2*pi-abs(angle1-angle2)));
        angle13 = min(abs(angle1-angle3),(2*pi-abs(angle1-angle3)));
        angle23 = min(abs(angle2-angle3),(2*pi-abs(angle2-angle3)));
        maxangle = max([angle12,angle13,angle23]);
        if angle12==maxangle        %第1条线与第2条线相连的情况
            Potential2_3 = Potential2_3+Kc*(sin(angle12)+0.5*(cos(angle13)+cos(angle23)))-Kl*(Lines(7,Nodes_3(m,1))+Lines(7,Nodes_3(m,2))+Lines(7,Nodes_3(m,3)));
        else if angle13==maxangle  %第1条线与第3条线相连的情况
                Potential2_3 = Potential2_3+Kc*(sin(angle13)+0.5*(cos(angle12)+cos(angle23)))-Kl*(Lines(7,Nodes_3(m,1))+Lines(7,Nodes_3(m,2))+Lines(7,Nodes_3(m,3)));
            else                %第2条线与第3条线相连的情况
                Potential2_3 = Potential2_3+Kc*(sin(angle23)+0.5*(cos(angle12)+cos(angle13)))-Kl*(Lines(7,Nodes_3(m,1))+Lines(7,Nodes_3(m,2))+Lines(7,Nodes_3(m,3)));
            end
        end
    end
end

if(flag_nodes_4)
    for m = 1:size(Nodes_4,1)
        [angle] = NodeCaculateAngle([Lines(1:4,Nodes_4(m,1)),Lines(1:4,Nodes_4(m,2)),Lines(1:4,Nodes_4(m,3)),Lines(1:4,Nodes_4(m,4))],4);
        angle1 = angle(1);
        angle2 = angle(2);
        angle3 = angle(3);
        angle4 = angle(4);
        angle12 = min(abs(angle1-angle2),(2*pi-abs(angle1-angle2)));
        angle13 = min(abs(angle1-angle3),(2*pi-abs(angle1-angle3)));
        angle14 = min(abs(angle1-angle4),(2*pi-abs(angle1-angle4)));
        angle23 = min(abs(angle2-angle3),(2*pi-abs(angle2-angle3)));
        angle24 = min(abs(angle2-angle4),(2*pi-abs(angle2-angle4)));
        angle34 = min(abs(angle3-angle4),(2*pi-abs(angle3-angle4)));
        %angle1 = min(abs(Lines(6,Nodes_4(m,1))-Lines(6,Nodes_4(m,2))),abs(180-(Lines(6,Nodes_4(m,1))-Lines(6,Nodes_4(m,2)))))*pi/180;
        %angle2 = min(abs(Lines(6,Nodes_4(m,1))-Lines(6,Nodes_4(m,3))),abs(180-(Lines(6,Nodes_4(m,1))-Lines(6,Nodes_4(m,3)))))*pi/180;
        %angle3 = min(abs(Lines(6,Nodes_4(m,1))-Lines(6,Nodes_4(m,4))),abs(180-(Lines(6,Nodes_4(m,1))-Lines(6,Nodes_4(m,4)))))*pi/180;
        %angle4 = min(abs(Lines(6,Nodes_4(m,2))-Lines(6,Nodes_4(m,3))),abs(180-(Lines(6,Nodes_4(m,2))-Lines(6,Nodes_4(m,3)))))*pi/180;
        %angle5 = min(abs(Lines(6,Nodes_4(m,2))-Lines(6,Nodes_4(m,4))),abs(180-(Lines(6,Nodes_4(m,2))-Lines(6,Nodes_4(m,4)))))*pi/180;
        %angle6 = min(abs(Lines(6,Nodes_4(m,3))-Lines(6,Nodes_4(m,4))),abs(180-(Lines(6,Nodes_4(m,3))-Lines(6,Nodes_4(m,4)))))*pi/180;
        maxangle = max([angle12,angle13,angle14,angle23,angle24,angle34]);
        if(maxangle==angle12||maxangle==angle34)
            Potential2_4 = Potential2_4+Kc*(sin(angle12)+sin(angle34))-Kl*(Lines(7,Nodes_4(m,1))+Lines(7,Nodes_4(m,2))+Lines(7,Nodes_4(m,3))+Lines(7,Nodes_4(m,4)));
        else if(maxangle==angle13||maxangle==angle24)
            Potential2_4 = Potential2_4+Kc*(sin(angle13)+sin(angle24))-Kl*(Lines(7,Nodes_4(m,1))+Lines(7,Nodes_4(m,2))+Lines(7,Nodes_4(m,3))+Lines(7,Nodes_4(m,4)));
            else
                Potential2_4 = Potential2_4+Kc*(sin(angle14)+sin(angle23))-Kl*(Lines(7,Nodes_4(m,1))+Lines(7,Nodes_4(m,2))+Lines(7,Nodes_4(m,3))+Lines(7,Nodes_4(m,4)));
            end
        end
    end
end

if(flag_nodes_others)
    for m = 1:size(Nodes_others,1)
        for n = 1:size( Nodes_others(Nodes_others(m,:)>0),2)
            Potential2_5 = Potential2_5+Ki*Lines(7,Nodes_others(m,n));
        end
    end
end

Potential2 = Potential2_1+Potential2_2+Potential2_3+Potential2_4+Potential2_5;
%%
%Potential1
%[Potential2_1 Potential2_2 Potential2_3 Potential2_4 Potential2_5]
%Potential2
Potential = Potential1+Potential2;
end

