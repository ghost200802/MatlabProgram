%%FFT in row of matrix		¾ØÕóĞĞ×öFFT: fty.m
function fs=fty(s);
fs=fftshift(fft(fftshift(s.'))).';
%fs=(fft((s.'))).';