%%IFFT in column of matrix	¾ØÕóÁĞ×öIFFT:iftx.m
function s=iftx(fs);
s=fftshift(ifft(fftshift(fs)));
%s=(ifft((fs)));
