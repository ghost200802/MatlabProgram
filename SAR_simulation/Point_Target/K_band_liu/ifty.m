%%IFFT in row of matrix		¾ØÕóĞĞ×öIFFT:ifty.m
function s=ifty(fs);
s=fftshift(ifft(fftshift(fs.'))).';
%s=(ifft((fs.'))).';