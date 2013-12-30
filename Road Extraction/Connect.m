function [data dataconnect] = Connect(length_thresh,angle_thresh)
%CONNECT Summary of this function goes here
%   Detailed explanation goes here
%%
%读入数据及预处理
[p1,p2,di,dir,l] = ReadNodes();

DataSize = size(p1,2);

data = zeros(7,DataSize);
data(1:2,:) = p1;
data(3:4,:) = p2;
data(5,:) = di;
data(6,:) = dir;
data(7,:) = l;
%data(6,:) = CaculateAngle(data(1:4,:));
%data(7,:) = CaculateLength(data(1:4,:));
%%
datacaculate = zeros(7,2*DataSize);
datacaculate(1,:) = [1:DataSize 1:DataSize];
datacaculate(2:3,:) = [p1,p2];
datacaculate(4:5,:) = [p2,p1];
datacaculate(6,:) = [di,di];
datacaculate(7,:) = [dir,dir];

datacaculate = MatrixSort(datacaculate,2);  %对所有点根据横坐标进行排序

%%
%选取需要进行连接的线
dataconnect = zeros(4,1);
K = 0;
for m = 1:2*DataSize
    for n = m+1:2*DataSize
        if datacaculate(1,m)~=datacaculate(1,n)         %验证是否属于同一条直线
            if abs(datacaculate(2,m)-datacaculate(2,n))<=length_thresh      %验证是否x方向距离小于阈值
                if sqrt((datacaculate(2,m)-datacaculate(2,n))^2+(datacaculate(3,m)-datacaculate(3,n))^2)<=length_thresh     %验证是否总的距离小于阈值
                    if abs(datacaculate(7,m)-datacaculate(7,n))<=angle_thresh || abs(datacaculate(7,m)-datacaculate(7,n))>=(180-angle_thresh)   %验证两条线之间的角度是否小于角度阈值                            
                        %R1 = sqrt((datacaculate(2,m)-datacaculate(4,m))^2+(datacaculate(3,m)-datacaculate(5,m))^2);
                        %R2 = sqrt((datacaculate(2,m)-datacaculate(2,n))^2+(datacaculate(3,m)-datacaculate(3,n))^2);
                        %R = sqrt((datacaculate(4,m)-datacaculate(2,n))^2+(datacaculate(5,m)-datacaculate(3,n))^2);
                        %th = acos((R1^2+R2^2-R^2)/(2*R1*R2))*180/pi;
                        %if  th>180-angle_thresh2                %使用余弦定理计算目标点与当前直线的夹角是否小于阈值,并且只连接目标直线上较近的点
                            K = K+1;
                            dataconnect(:,K) = [datacaculate(2,m),datacaculate(3,m),datacaculate(2,n),datacaculate(3,n)];
                        %end
                    end
                end
            else
                continue
            end       
        end
    end
end

ConnectSize = size(dataconnect,2);
dataconnect(5,:) = zeros(1,ConnectSize);        %将联结线段的di设置为0
dataconnect(6,:) = CaculateAngle(dataconnect(1:4,:));   %计算并赋值dir及l
dataconnect(7,:) = CaculateLength(dataconnect(1:4,:));
