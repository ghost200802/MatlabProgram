function [ output_signal ] = ValidData( input_signal,Range )
%VALIDDATA Summary of this function goes here
%   Detailed explanation goes here
threshold = 1e-1;           %���ò���������������ֵ
[col,row] = size(input_signal);
caculate_signal = abs(input_signal)/(max(max(abs(input_signal))));     %���������������ֵ���й�һ��
signal_average = mean(caculate_signal(caculate_signal>1e-2));
thresh = signal_average*threshold;
index = caculate_signal>thresh;     %������Ҫ�������ֵ
input_left = col;               %��ʼ�������������ֵ�����濪ʼ��������
input_right = 1;
for i = 1:row
    input_left = min(input_left,find(index(:,i),1,'first'));
    input_right = max(input_right,find(index(:,i),1,'last'));
end
input_left = max(1,input_left-Range);                   %��ֹ���ֵ����Сֵ�����߽�
input_right = min(col,input_right+Range);
output_signal = input_signal(input_left:input_right,:);  %ѡȡ����Ҫ���������
end

