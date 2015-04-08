function [ entropy ] = imageEntropy( input_signal )
%IMAGEENTOPY Summary of this function goes here
%   Detailed explanation goes here
input_signal = abs(input_signal);
entropy = sum(sum((input_signal(input_signal~=0).*log(input_signal(input_signal~=0)))))/sum(sum(abs(input_signal)));

end

