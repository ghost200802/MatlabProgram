function [target N_target] = Target
%TARGET Summary of this function goes here
%   Detailed explanation goes here
%������������ȡĿ��
%Ŀ��ĸ�ʽ ����ɢ��ϵ���� Ŀ����������ϵx����/m�� Ŀ����������ϵy����/m, Ŀ��x�����ٶ�/(m/s), Ŀ��y�����ٶ�/(m/s)
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


