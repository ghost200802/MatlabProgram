function [ output_signal ] = LinearShift( input_signal,K,theta)
%LINEARSHIFT Summary of this function goes here
%   Detailed explanation goes here
[col,row] = size(input_signal);
output_signal = zeros(col,row);
for i = 1:row
    output_signal(:,i) = circshift(input_signal(:,i),[round(i*K),0])*exp(1i*i*theta);
end

end

