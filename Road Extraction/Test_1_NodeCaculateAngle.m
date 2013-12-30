function Test_1_NodeCaculateAngle
%TEST_1_NODECACULATEANGLE Summary of this function goes here
%   Detailed explanation goes here
%Nodes = [0 0 0 0; 0 0 0 0; 1 1 -1 -1; 1 -1 1 -1];
%Nodes = [ 0 0 0 0; 0 0 0 0;1 0 -1 0; 0 1 0 -1];
Nodes = [ 0 0 0 0; 0 0 0 0; 2 1 -1 -2; 1 2 2 1];

[angle] = NodeCaculateAngle(Nodes,4);
angle1 = angle(1);
angle2 = angle(2);
angle12 = min(abs(angle1-angle2),(2*pi-abs(angle1-angle2)));

end

