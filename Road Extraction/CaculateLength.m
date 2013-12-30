function [ length ] = CaculateLength( coordinate )
%CACULATELENGTH Summary of this function goes here
%   Detailed explanation goes here

length = sqrt((coordinate(1,:)-coordinate(3,:)).^2+(coordinate(2,:)-coordinate(4,:)).^2);

end

