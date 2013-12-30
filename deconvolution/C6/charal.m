function x=charal(y,h)
%x-复原后图像
%y-给定的降晰图像
%h-降晰函数
%%
%估计噪声
[n,m]=size(y);w=ones(5,5)/25;
a=conv2(y,w);
a1=a(3:n+2,3:m+2);
v=(y-a1).^2;
a=conv2(v,w);
v=a(3:n+2,3:m+2);
deta=n*m*min(min(v));
%%
%约束最小二乘算法
c=[0 1 0;1 -4 1;0 1 0]/8;
L1=2*n;L2=2*m;
Y=fft2(y,L1,L2);
H=fft2(h,L1,L2);
C=fft2(c,L1,L2);
%Charalambous估计，用二分法决定lamada
lamada0=0;lamada1=3e8;lamada=(lamada0+lamada1)/2;
fai=mean(mean((abs(C).^2.*abs(Y)./(lamada*abs(H).^2+abs(C).^2)).^2))-deta;
while abs(fai)>1e-5
    if fai>0
        lamada0=lamada;
    else
        lamada1=lamada;
    end
    lamada=(lamada0+lamada1)/2;
    fai=mean(mean((abs(C).^2.*abs(Y)./(lamada*abs(H).^2+abs(C).^2)).^2))-deta;
end
alpha=1/lamada;
X=conj(H).*Y./(abs(H).^2+alpha*abs(C).^2);
x=ifft2(X);x=x(1:m,1:n);

