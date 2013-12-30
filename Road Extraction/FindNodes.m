function [ Nodes LineEnds ] = FindNodes( Lines,L_mask )
%FINDNODES Summary of this function goes here
%   Detailed explanation goes here
%Ϊֱ�������2�ţ���1��Ϊֱ�ߵı�ţ���¼��Node�У����һ��Ϊ���룬ȷ��ֱ���Ƿ���Ҫ����,ͬʱ��ֱ�߽��и��ƣ���2���ڵ�ͬʱ�Ų�
LineSizeOrigin = size(Lines,2);
Lines = [[1:LineSizeOrigin,1:LineSizeOrigin];[Lines(1:2,:),Lines(3:4,:)];[L_mask,L_mask]];   
%ѡȡ��Lines��L_maskΪ1�������Ҫ���д������  
Lines = Lines(:,Lines(4,:)==1);   
LineSize = size(Lines,2);                                                       
Lines = MatrixSort(Lines,2);



%Nodes���ݽṹ��Nodes��i,:�������i���ڵ㣬Nodes(i,j)�����i���ڵ��еĵ�j����
Nodes = zeros(1,0);

%LineEnds���ݽṹ����1��Ϊ�ߵı�ţ���2��Ϊ�ߵ�ĳһ���˵�ڵ㣬��3��Ϊ�ߵ���һ���˵�ڵ�(���ﻹû�м����߱��)
LineEnds = zeros(2,LineSizeOrigin);

if(LineSize>0)                  %�ж��Ƿ�ǿ�
    Nodes(1,1) = Lines(1,1);    %����Ϊ��ʼ��ѭ�����������    
    NodeSize = 1;               %��Nodes����
    CurrentNodeCount = 1;       %��ǰNode��Line����
    current_node = [Lines(2,1),Lines(3,1)];
    if(LineSize>1)              %�ж��Ƿ���2��Ԫ��
        for m =2:LineSize
            if(current_node(1)==Lines(2,m) && current_node(2)==Lines(3,m))      %���жϵĽڵ��뵱ǰ�洢�Ľڵ���ͬ������뵱ǰ��node��
                CurrentNodeCount = CurrentNodeCount+1;          %���ӵ�ǰNode��Line����
                Nodes(NodeSize,CurrentNodeCount) = Lines(1,m);  %��Line�ı��д��Nodes��
                if(LineEnds(1,Lines(1,m))==0)                            %��Node���д��LineEnds�У�Ϊ�����ṩ�˿���
                    LineEnds(1,Lines(1,m)) = NodeSize;
                else
                    LineEnds(2,Lines(1,m)) = NodeSize;
                end                        
            else
                NodeSize = NodeSize+1;                          %���жϲ�ͬ����д����һ���ڵ���
                CurrentNodeCount = 1;
                current_node = [Lines(2,m),Lines(3,m)];
                Nodes(NodeSize,CurrentNodeCount) = Lines(1,m);
                if(LineEnds(1,Lines(1,m))==0)                            %��Node���д��LineEnds�У�Ϊ�����ṩ�˿���
                    LineEnds(1,Lines(1,m)) = NodeSize;
                else
                    LineEnds(2,Lines(1,m)) = NodeSize;
                end     
            end
        end
    end
end

%��ʵ��������m�Ǵ�2��ʼ������������1���ڵ�û�мӽ�����������������ڵ�϶�����ͼ���Ե�����Թ�ϵ�������ø���



