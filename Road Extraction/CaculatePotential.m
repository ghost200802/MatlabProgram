function [ Potential ] = CaculatePotential( Lines,L_mask )
%CACULATEPOTENTIAL Summary of this function goes here
%   Detailed explanation goes here
%%
%数据初始化
t1 = 0.2;
t2 = 0.3;
Ke = 0.21;
Kl = 0.12;
Kc = 0.5;
Ki = 0.8;

Kp2 = 10;

thresh1 = 0.7;

Kp3 = 0.3;
Anglep3 = pi/15;


[Nodes LineEnds] = FindNodes(Lines,L_mask);
NodesReserve = Nodes;

LineSize = size(Lines,2);
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
        Potential2_2 = Potential2_2+Kc*(cos((Kp2^angle12-1)/Kp2^pi*pi)+thresh1)-Kl*(Lines(7,Nodes_2(m,1))+Lines(7,Nodes_2(m,2)));
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
            Potential2_3 = Potential2_3+Kc*((cos((Kp2^angle12-1)/Kp2^pi*pi)+thresh1)+0.5*(abs(cos(angle13))+abs(cos(angle23))))-Kl*(Lines(7,Nodes_3(m,1))+Lines(7,Nodes_3(m,2))+Lines(7,Nodes_3(m,3)));
        else if angle13==maxangle  %第1条线与第3条线相连的情况
                Potential2_3 = Potential2_3+Kc*((cos((Kp2^angle13-1)/Kp2^pi*pi)+thresh1)+0.5*(abs(cos(angle12))+abs(cos(angle23))))-Kl*(Lines(7,Nodes_3(m,1))+Lines(7,Nodes_3(m,2))+Lines(7,Nodes_3(m,3)));
            else                %第2条线与第3条线相连的情况
                Potential2_3 = Potential2_3+Kc*((cos((Kp2^angle23-1)/Kp2^pi*pi)+thresh1)+0.5*(abs(cos(angle12))+abs(cos(angle13))))-Kl*(Lines(7,Nodes_3(m,1))+Lines(7,Nodes_3(m,2))+Lines(7,Nodes_3(m,3)));
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
            Potential2_4 = Potential2_4+Kc*((cos((Kp2^angle12-1)/Kp2^pi*pi)+thresh1)+(pi-angle34))-Kl*(Lines(7,Nodes_4(m,1))+Lines(7,Nodes_4(m,2))+Lines(7,Nodes_4(m,3))+Lines(7,Nodes_4(m,4)));
        else if(maxangle==angle13||maxangle==angle24)
            Potential2_4 = Potential2_4+Kc*((cos((Kp2^angle13-1)/Kp2^pi*pi)+thresh1)+(pi-angle24))-Kl*(Lines(7,Nodes_4(m,1))+Lines(7,Nodes_4(m,2))+Lines(7,Nodes_4(m,3))+Lines(7,Nodes_4(m,4)));
            else
                Potential2_4 = Potential2_4+Kc*((cos((Kp2^angle14-1)/Kp2^pi*pi)+thresh1)+(pi-angle23))-Kl*(Lines(7,Nodes_4(m,1))+Lines(7,Nodes_4(m,2))+Lines(7,Nodes_4(m,3))+Lines(7,Nodes_4(m,4)));
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
%计算势能3
%{
%势能3是如果补充出来的线把两条提取出来的线联结成了一条角度很小的较长直线，则势能3为负，以达到保证存留能够将长的直线联结起来的目的
Potential3 = 0;

%LineEnds数据结构：第1排为线的编号，第2排为线的某一个端点节点，第3排为线的另一个端点节点
LineEnds = [1:LineSize;LineEnds;Lines(5,:)];  

LineEnds = LineEnds(:,LineEnds(3,:)>0);         %保证计算得到的结果都是两端都有连接的线
LineEnds = LineEnds(:,LineEnds(4,:)==0);        %这里只计算补充出来的线

for m = 1:size(LineEnds,2)
    Node1 = NodesReserve(LineEnds(2,m),:);
    Node2 = NodesReserve(LineEnds(3,m),:);
    Node1 = Node1(Node1>0);
    Node2 = Node2(Node2>0);
    Line1 = 0;
    Line2 = 0;
    for n = 1:size(Node1,2)         %从Node1中选取提取出的线段
        if(Lines(5,Node1(n))>0)
            Line1 = Node1(n);
            break
        end
    end
    for n = 1:size(Node2,2)         %从Node2中选取提取出的线段
        if(Lines(5,Node2(n))>0)
            Line2 = Node2(n);
            break
        end
    end
    if(Line1>0 && Line2>0)      %确保两侧都有联结
        CaculateNode1 = [Lines(1:4,LineEnds(1,m)),Lines(1:4,Line1)];
        CaculateNode2 = [Lines(1:4,LineEnds(1,m)),Lines(1:4,Line2)];
        [angle_temp] = NodeCaculateAngle(CaculateNode1,2);
        angle1_1 = angle_temp(1);
        angle2 = angle_temp(2);
        [angle_temp] = NodeCaculateAngle(CaculateNode2,2);
        angle1_2 = angle_temp(1);
        angle3 = angle_temp(2);
        %这里进行了交叉，因为本来如果不交叉的话，最优的情况是夹角为180°，不好判断
        %这里angle1_1与angle1_2因为是相同直线的两端，所以正好相差180°，如果采用交叉，则最优为0，比较好判断
        angle12 = min(abs(angle1_2-angle2),(2*pi-abs(angle1_2-angle2)));
        angle13 = min(abs(angle1_1-angle3),(2*pi-abs(angle1_1-angle3)));
        angle12 = min((angle12-Anglep3),0);
        angle13 = min((angle13-Anglep3),0);
        AddLength = Lines(7,LineEnds(1,m))+Lines(7,Line1)+Lines(7,Line2);
        
        Potential3 = Potential3+Kp3*AddLength*(angle12+angle13)
    end
end
%}
%%
%Potential1
%[Potential2_1 Potential2_2 Potential2_3 Potential2_4 Potential2_5]
%Potential2
%Potential = Potential1+Potential2+Potential3;
Potential = Potential1+Potential2;
end

