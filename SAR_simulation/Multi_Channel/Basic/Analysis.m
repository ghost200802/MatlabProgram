function Analysis
%ANALYSIS Summary of this function goes here
%������������
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

