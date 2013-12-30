function x=maxentrop(y,h)
%x-复原后图像
%y-给定的降晰图像
%h-降晰函数
%%
%估计局部方差
[n,m]=size(y);w=ones(5,5)/25;
L=m*n;
a=conv2(y,w);
a1=a(3:n+2,3:m+2);
v=(y-a1).^2;
a=conv2(v,w);
v=a(3:n+2,3:m+2);
D=diag(reshape(v',L,1));
%%
%计算矩阵B
H0=fft2(h,n,m);H=diag(reshape(H0',L,1));
for k=1:n
    for l=1:m
        for u=1:n
            for v=1:m
                W(m*(k-1)+u,n*(l-1)+v)=exp(j*2*pi*(u*k/n+v*l/m));
            end
        end
    end
end
B=W*H*inv(W);
y1=reshape(y,L,1);alpha=1;lamada=0.01;eps=0.1*L;
x0=mean(y1)*ones(L,1);x1=x0;d=L;
while abs(d)>eps
    x1=inv(B'*D*B)*(B'*D*y1-alpha*(log(x1)-log(x0)));
    Q=(B*x1-y1)'*D*(B*x1-y1);
    d=Q-L;
    if d>0
        alpha=alpha+lamada;
    elseif d<0
        alpha=alpha-lamada;
    end
end
x=reshape(x1,n,m);
