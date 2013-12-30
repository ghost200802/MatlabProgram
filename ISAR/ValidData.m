function [ output_signal ] = ValidData( input_signal,Range )
%VALIDDATA Summary of this function goes here
%   Detailed explanation goes here
threshold = 1e-1;           %设置不计算的数据最大阈值
[col,row] = size(input_signal);
caculate_signal = abs(input_signal)/(max(max(abs(input_signal))));     %对输入数据以最大值进行归一化
signal_average = mean(caculate_signal(caculate_signal>1e-2));
thresh = signal_average*threshold;
index = caculate_signal>thresh;     %查找需要计算的数值
input_left = col;               %初始化需计算矩阵的数值，下面开始进行搜索
input_right = 1;
for i = 1:row
    input_left = min(input_left,find(index(:,i),1,'first'));
    input_right = max(input_right,find(index(:,i),1,'last'));
end
input_left = max(1,input_left-Range);                   %防止最大值与最小值超出边界
input_right = min(col,input_right+Range);
output_signal = input_signal(input_left:input_right,:);  %选取出需要计算的数据
end

