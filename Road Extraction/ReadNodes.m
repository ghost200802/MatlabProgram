function [ n_p1,n_p2,n_di,n_dir,n_l ] = ReadNodes
%READNODES Summary of this function goes here
%   Detailed explanation goes here
load('nodes2.mat');
nodesize = size(nodes,2);
n_p1 = zeros(2,nodesize);
n_p2 = zeros(2,nodesize);
n_di = zeros(1,nodesize);
n_dir = zeros(1,nodesize);
n_l = zeros(1,nodesize);

for i = 1:nodesize
    n_p1(:,i) = [nodes(i).p1(2),nodes(i).p1(1)];
    n_p2(:,i) =[nodes(i).p2(2),nodes(i).p2(1)];
    n_di(i) = nodes(i).di;
    n_dir(i) = mod(nodes(i).dir,180);
    n_l(i) = nodes(i).l;
end

end

