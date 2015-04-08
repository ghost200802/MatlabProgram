function [ output_signal] = CRRC( input_signal,Omega )
%SRRC Summary of this function goes here
%   Detailed explanation goes here
[ F0,~,B,PRF,~,~,c ] = ParametersSystem();
%[ ~,~,Omega0,~,~,~] = ParametersTarget();
[R_scale,A_scale] = size(input_signal);


Fc = F0+B/2;
K = (-1)*(pi*Fc*Omega^2)/(B*PRF^2);
R_left = round(-R_scale/2);
R_right = R_scale+R_left-1;
A_left = round(-A_scale/2);
A_right = A_scale+A_left-1;
phase = exp(1i*K*((R_left:R_right).')*((A_left:A_right)).^2);
%phase = exp(1i*K*(ones(1,size((R_left:R_right),2)).')*((A_left:A_right)/6).^2);
output_signal = input_signal.*phase;
end

