%%FFT in column of matrix		¾ØÕóÁĞ×öFFT:ftx.m
function fs=ftx(s);
fs=fftshift(fft(fftshift(s)));
%fs=(fft((s)));
