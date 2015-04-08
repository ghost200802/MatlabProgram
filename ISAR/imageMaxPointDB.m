function [ maxPoint ] = imageMaxPointDB( input_signal )
%IMAGEENTOPY Summary of this function goes here
%   Detailed explanation goes here
maxPoint = max(max(abs(input_signal)));

maxPoint = 20*log(maxPoint)/log(10);
end

