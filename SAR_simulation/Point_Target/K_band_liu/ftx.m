%%FFT in column of matrix		��������FFT:ftx.m
function fs=ftx(s);
fs=fftshift(fft(fftshift(s)));
%fs=(fft((s)));
