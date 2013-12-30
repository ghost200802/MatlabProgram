function  C6P1
%C6P1 Summary of this function goes here
%   Detailed explanation goes here
hn = [0.0232 0.0534 0.0475 0.0226 0.1087 0.3761 0.7822 1.0000 0.8247 0.4038 0.1291 0.0582 0.0526 0.0138 0.0706];
k=-7:7;A=1;alpha=1;
lamada=0.1;eps=1e-8;
dalpha=1;dA=1;
while dalpha^2+dA^2>eps
    h=A*exp(-alpha*k.^2);
    dalpha=sum(2*(h-hn).*h.*(-k.^2));
    dA=sum(2*(h-hn).*exp(-alpha*k.^2));
    alpha=alpha-lamada*dalpha;
    A=A-lamada*dA;
end
A
alpha
h=A*exp(-alpha*k.^2)
E=sum((h-hn).^2)/15
plot(hn,'b-o');
hold on
plot(h,'r');
end

