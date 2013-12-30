function [ angle ] = NodeCaculateAngle( Nodes,length )
%NODECACULATEANGLE Summary of this function goes here
%   Detailed explanation goes here
angle = zeros(1,length);

%%
%找到相同的点
if((Nodes(1,1)==Nodes(1,2)&&Nodes(2,1)==Nodes(2,2))||(Nodes(1,1)==Nodes(3,2)&&Nodes(2,1)==Nodes(4,2)))
    NodePoint = [Nodes(1,1),Nodes(2,1)];
else 
    NodePoint = [Nodes(3,1),Nodes(4,1)];
end

%%
%计算角度
for m = 1:length
    %计算dx和dy，从相同点起始，指向需要计算的点
    if(NodePoint(1,1)==Nodes(1,m)&&NodePoint(1,2)==Nodes(2,m))
        dx = Nodes(3,m)-Nodes(1,m);
        dy = Nodes(4,m)-Nodes(2,m);
    else
        dx = Nodes(1,m)-Nodes(3,m);
        dy = Nodes(2,m)-Nodes(4,m);
    end
    %计算角度，范围从0-359
    if(dy==0)
        if(dx>=0)
            angle(m)=0;
        else
            angle(m)=pi;
        end
    else
        angle(m) =atan(dy/dx);
        if(dx<0)
            angle(m) = angle(m)+pi;
        else if(dy<0)
            angle(m) = angle(m)+2*pi;
            end
        end
    end
end   



end

