%%IFFT in column of matrix	��������IFFT:iftx.m
function s=iftx(fs);
s=fftshift(ifft(fftshift(fs)));
%s=(ifft((fs)));
