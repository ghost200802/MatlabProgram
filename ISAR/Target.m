function [target N_target] = Target
%TARGET Summary of this function goes here
%   Detailed explanation goes here
%������������ȡĿ��
%Ŀ��ĸ�ʽ ����ɢ��ϵ���� Ŀ����������ϵx����/m�� Ŀ����������ϵy����/m
fid=fopen('Target_9_4dx_range.txt');
target = zeros(1,3);
i = 0;
while ~feof(fid)
    i = i+1;
    [temp_target,Count]=fscanf(fid,'%f',3);
    target(i,:) = temp_target;    
end
N_target = i;
fclose(fid);
end


