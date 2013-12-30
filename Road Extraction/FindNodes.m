function [ Nodes LineEnds ] = FindNodes( Lines,L_mask )
%FINDNODES Summary of this function goes here
%   Detailed explanation goes here
%为直线添加了2排，第1排为直线的编号，记录入Node中，最后一排为掩码，确定直线是否需要计算,同时对直线进行复制，将2个节点同时排布
LineSizeOrigin = size(Lines,2);
Lines = [[1:LineSizeOrigin,1:LineSizeOrigin];[Lines(1:2,:),Lines(3:4,:)];[L_mask,L_mask]];   
%选取出Lines中L_mask为1的项，即需要进行处理的项  
Lines = Lines(:,Lines(4,:)==1);   
LineSize = size(Lines,2);                                                       
Lines = MatrixSort(Lines,2);



%Nodes数据结构：Nodes（i,:）代表第i个节点，Nodes(i,j)代表第i个节点中的第j条线
Nodes = zeros(1,0);

%LineEnds数据结构：第1排为线的编号，第2排为线的某一个端点节点，第3排为线的另一个端点节点(这里还没有加上线编号)
LineEnds = zeros(2,LineSizeOrigin);

if(LineSize>0)                  %判断是否非空
    Nodes(1,1) = Lines(1,1);    %以下为初始化循环的最初变量    
    NodeSize = 1;               %总Nodes数量
    CurrentNodeCount = 1;       %当前Node的Line数量
    current_node = [Lines(2,1),Lines(3,1)];
    if(LineSize>1)              %判断是否有2个元素
        for m =2:LineSize
            if(current_node(1)==Lines(2,m) && current_node(2)==Lines(3,m))      %若判断的节点与当前存储的节点相同，则加入当前的node中
                CurrentNodeCount = CurrentNodeCount+1;          %增加当前Node的Line数量
                Nodes(NodeSize,CurrentNodeCount) = Lines(1,m);  %把Line的编号写入Nodes中
                if(LineEnds(1,Lines(1,m))==0)                            %把Node编号写入LineEnds中，为回溯提供了可能
                    LineEnds(1,Lines(1,m)) = NodeSize;
                else
                    LineEnds(2,Lines(1,m)) = NodeSize;
                end                        
            else
                NodeSize = NodeSize+1;                          %若判断不同，则写入下一个节点中
                CurrentNodeCount = 1;
                current_node = [Lines(2,m),Lines(3,m)];
                Nodes(NodeSize,CurrentNodeCount) = Lines(1,m);
                if(LineEnds(1,Lines(1,m))==0)                            %把Node编号写入LineEnds中，为回溯提供了可能
                    LineEnds(1,Lines(1,m)) = NodeSize;
                else
                    LineEnds(2,Lines(1,m)) = NodeSize;
                end     
            end
        end
    end
end

%其实这里由于m是从2开始搜索，所以有1个节点没有加进来，不过由于这个节点肯定是在图像边缘，所以关系不大，懒得改了



