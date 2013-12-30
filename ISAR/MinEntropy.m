function [ t_move ] = MinEntropy( U_sum,U_now,Range )
%MINENTROPY Summary of this function goes here
%   Detailed explanation goes here

U_sum = abs(U_sum)/sum(sum(abs(U_sum)));        %����������ȡabs�ҽ��й�һ������
U_now = abs(U_now)/sum(sum(abs(U_now)));

Entropy = zeros(1,2*Range+1);
U_temp = circshift(U_now,-Range);               %��U_temp��ֵΪU_now������Range����ˣ�Ȼ��ÿ������1      


for i = -Range:Range  
    U = U_sum+U_temp;
    U = U/sum(sum(U));
    Entropy(i+Range+1) = (-1)*sum(U(U~=0).*log(U(U~=0)));       %�������(U~=0)��Ϊ�˷�ֹ��U��Ԫ��ȡֵΪ0ʱ��U.*log(U)����NaN
    U_temp = circshift(U_temp,1);
end

[~,col] = find(Entropy == min(min(Entropy)));
t_move = col(1)-Range-1;
