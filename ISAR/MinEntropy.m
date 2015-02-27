function [ t_move ] = MinEntropy( U_sum,U_now,Range,Shift)
%MINENTROPY Summary of this function goes here
%   Detailed explanation goes here

U_sum = abs(U_sum)/max(max(abs(U_sum)));        %对输入数据取abs且进行归一化处理
% U_sum = U_sum > 0.1;
% figure,plot(U_sum)
U_now = abs(U_now)/max(max(abs(U_now)));
% U_now = U_now > 0.1;
% figure,plot(U_now)

Entropy = zeros(1,2*Range+1);

U_temp = circshift(U_now,[-round(Shift)-Range,0]);               %将U_temp赋值为U_now左移至Range最左端，然后每次右移1      

for i = -Range:Range  
    U = U_sum+U_temp;
    U = U/sum(sum(U));
    Entropy(i+Range+1) = (-1)*sum(U(U~=0).*log(U(U~=0)));       %这里加上(U~=0)是为了防止当U中元素取值为0时，U.*log(U)出现NaN
    U_temp = circshift(U_temp,[1,0]);
end
[~,col] = find(Entropy == min(min(Entropy)));
% col(1)-Range-1
t_move = col(1)-Range-1-round(Shift);
