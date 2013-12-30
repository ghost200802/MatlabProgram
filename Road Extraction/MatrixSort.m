function [ output] = MatrixSort( input,n )
%MATRIXSORT Summary of this function goes here
%   Detailed explanation goes here

[col,row] = size(input);
output = zeros(col,row);
if(n<=row)
    [~,Index] = sort(input(n,:));   
    for i = 1:col
        temp_col = input(i,:);
        output(i,:) = temp_col(Index);
    end
end

