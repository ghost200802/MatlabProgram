function [ OutputSignal ] = IFFTX( InputSignal )
%FFTX Summary of this function goes here
%   Detailed explanation goes here
OutputSignal = ifft(ifftshift(InputSignal.',1)).';

end
