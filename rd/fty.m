%%FFT in row of matrix		��������FFT: fty.m
function fs=fty(s);
fs=fftshift(fft(fftshift(s.'))).';
%fs=(fft((s.'))).';