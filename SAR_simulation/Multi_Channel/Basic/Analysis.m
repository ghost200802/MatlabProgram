function Analysis
%ANALYSIS Summary of this function goes here
%调用其他东西
%   Detailed explanation goes here
close all;
clear all;

PRF = 1495;
FFT_Analysis(PRF);                      
Azimuth_Compression(PRF);

PRF = 1644.5;
FFT_Analysis(PRF);
Azimuth_Compression(PRF);

end

