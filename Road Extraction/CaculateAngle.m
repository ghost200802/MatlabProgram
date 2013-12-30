function [ angle ] = CaculateAngle( coordinate )
%CACULATEANGLE Summary of this function goes here
%   Detailed explanation goes here

angle = round(mod(-1*atan((coordinate(4,:)-coordinate(2,:))./(coordinate(3,:)-coordinate(1,:)))*180/pi,180));

exception = (coordinate(3,:)==coordinate(1,:));

angle(exception) = 90;

end

