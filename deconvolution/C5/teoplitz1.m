function x=teoplitz1(Rh,g,L,N1,N2)
for i=1:N1
    if i==1
        a=Rh(1,1:N2)';
    else
        a=Rh(L-i+2,1:N2)';
    end
    b=Rh(i,1:N2);
        G(:,:,i)=toeplitz(a,b);
end
    x0=inv(G(:,:,1))*g(1,:)';
    Z=inv(G(:,:,1))*G(:,:,2)';
    W=inv(G(:,:,1))*G(:,:,2);
    Q=G(:,:,2);P=Q';   
    for j=2:N1
      xi=inv(G(:,:,1)-Q*Z)*(g(j,:)'-Q*x0); 
      yi=x0-Z*xi;x0=[xi;yi];
      if j<N1
          Zb=inv(G(:,:,1)-P*W)*(G(:,:,j+1)'-P*Z);Za=Z-W*Zb;
          Wc=inv(G(:,:,1)-Q*Z)*(G(:,:,j+1)-Q*W);Wd=W-Z*Wc;
          Z=[Za;Zb];W=[Wc;Wd];Q=[Q G(:,:,j+1)];P=[G(:,:,j+1)' P];
      end 
    end
    y=reshape(x0',N2,N1);
    x=y';

