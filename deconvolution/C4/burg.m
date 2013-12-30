function [ A,E ] = burg( y,M )
%BURG Summary of this function goes here
%   Detailed explanation goes here
N=length(y);
A1=zeros(1,M);
Ef=y;
Eb=y;
E(1)=sum(y.^2)/N;
A1(1)=1;
E=A1;
for i=2:M
    c=sum(Ef(i:N).*Eb(i-1:N-1));
    d=sum(Ef(i:N).^2)+sum(Eb(i-1:N-1).^2);
    gamma=2*c/d;
    A1(i)=-gamma;
    if i>2
        A1(2:i-1)=A1(2:i-1)-gamma*A1(i-1:-1:2);
    end
    B=Ef(i:N);
    Ef(i:N)=B-gamma*Eb(i-1:N-1);
    Eb(i:N)=Eb(i-1:N-1)-gamma*B;
    E(i)=(1-gamma^2)*E(i-1);
end
E=E(M);
A=A1(2:M);
end

