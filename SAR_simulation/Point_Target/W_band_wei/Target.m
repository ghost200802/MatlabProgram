function [target N_target] = Target
%TARGET Summary of this function goes here
%   Detailed explanation goes here
%本函数用来读取目标
%目标的格式 后向散射系数， 目标中心坐标系x坐标/m， 目标中心坐标系y坐标/m, 目标x方向速度/(m/s), 目标y方向速度/(m/s)
fid=fopen('Target.txt');
target = zeros(1,5);
i = 0;
while ~feof(fid)
    i = i+1;
    [temp_target,~]=fscanf(fid,'%f',5);
    target(i,:) = temp_target;    
end
N_target = i;
fclose(fid);
end


