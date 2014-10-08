function [ OutputSignal ] = FFTX( InputSignal )
%FFTX Summary of this function goes here
%   Detailed explanation goes here
OutputSignal = fftshift(fft(InputSignal.'),1).';

end

