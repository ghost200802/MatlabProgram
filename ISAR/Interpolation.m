function [ output_signal ] = Interpolation( input_signal,X_Points )
%INTERPOLATION Summary of this function goes here
%   Detailed explanation goes here
%%
%{
%�������ź�ͨ��Ƶ��0�ķ�������K_interpolation���Ĳ�ֵ
[col,row] =size(input_signal);
output_signal = zeros(col*K_interpolation,row);
input_signal = fft(input_signal);
output_signal(1:col,1:row) = input_signal;
output_signal = ifft(output_signal);
%}
%%
[~,row] =size(input_signal);
[X,Y] = meshgrid(1:row,X_Points);
output_signal = interp(input_signal,X,Y,'spline');
end

