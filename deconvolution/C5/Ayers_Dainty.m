function [x,h]=Ayers_Dainty(y,x0,h0,round)
[M1,M2]=size(h0);
[N1,N2]=size(x0);
L1=M1+N1-1;L2=M2+N2-1;
L=max(L1,L2);Yk=fft2(y,L,L);x=x0;h=h0;Hk=fft2(h,L,L);
for i=1:round
    rx=0.2*conj(Hk(1,1))*Hk(1,1);
    Xk=conj(Hk).*Yk./(conj(Hk).*Hk+rx);
    x=ifft2(Xk);x=x(1:N1,1:N2);
    Xk=fft2(x,L,L);rh=0.2*conj(Xk(1,1))*Xk(1,1);
    Hk=conj(Xk).*Yk./(conj(Xk).*Xk+rh);
    h=ifft2(Hk);h=h(1:M1,1:M2);
    Hk=fft2(h,L,L);
end
