function [ output_signal] = CRRC( input_signal )
%SRRC Summary of this function goes here
%   Detailed explanation goes here
[ F0,~,B,PRF,~,~,c ] = ParametersSystem();
[ ~,~,Omega0,~,~,~] = ParametersTarget();

Fc = F0+B/2;
K = (-1)*(2*pi*Fc*Omega0^2)/(c*PRF^2);
[R_scale,A_scale] = size(input_signal);
R_left = round(-R_scale/2);
R_right = R_scale+R_left-1;
A_left = round(-A_scale/2);
A_right = A_scale+A_left-1;
phase = exp(1i*K*((R_left:R_right).')*((A_left:A_right)/6).^2);%这个本来的计算结果是没有6这个系数的，但是在实际使用中，当加入这个系数后，结果才正确
output_signal = input_signal.*phase;
end

