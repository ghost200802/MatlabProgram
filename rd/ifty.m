%%IFFT in row of matrix		��������IFFT:ifty.m
function s=ifty(fs);
s=fftshift(ifft(fftshift(fs.'))).';
%s=(ifft((fs.'))).';