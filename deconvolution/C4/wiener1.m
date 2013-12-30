function x=winener1(y,h)

gama=input('gama= ');
N=max(length(y),length(h));
Hk=fft(h,N);
Yk=fft(y,N);
HFk=conj(Hk)./(Hk.*conj(Hk)+gama);
Xk=Yk.*HFk;
x=ifft(Xk,N);

end

