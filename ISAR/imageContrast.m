function [ contrast ] = imageContrast( input_signal )
%IMAGEENTOPY Summary of this function goes here
%   Detailed explanation goes here
input_signal = abs(input_signal);
[M,N] = size(input_signal);

error = input_signal-mean(mean(input_signal));

signal_mse = sqrt(1/(M*N)*sum(sum(error.^2)));


contrast = signal_mse/mean(mean(input_signal));

end

