function [x,h]=blind_decon(y,x0,h0,eps)
%y观察序列 x0，h0起始值 eps达到误差
[M1,M2]=size(h0);
[N1,N2]=size(x0);
L1=M1+N1-1;L2=M2+N2-1;
L=max(L1,L2);Yk=fft2(y,L,L);x=x0;h=h0;
Xk=fft2(x,L,L);Hk=fft2(h,L,L);
E=abs(sum(sum(conj((Yk-Hk.*Xk)).*(Yk-Hk.*Xk))));
while E>eps
    g=ifft2(conj(Xk).*Yk);g=g(1:M1,1:M2);
    Rx=ifft2(conj(Xk).*Xk);
    h=teoplitz1(Rx,g,L,M1,M2);
    Hk=fft2(h,L,L);
    g=ifft2(conj(Hk).*Yk);g=g(1:N1,1:N2);
    Rh=ifft2(conj(Hk).*Hk);
    x=teoplitz1(Rh,g,L,N1,N2);
    Xk=fft2(x,L,L);
    E=abs(sum(sum(conj((Yk-Hk.*Xk)).*(Yk-Hk.*Xk))));
end