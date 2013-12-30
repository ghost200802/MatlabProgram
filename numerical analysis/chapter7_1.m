function chapter7_1
%CHAPTER7_1 Summary of this function goes here
%   Detailed explanation goes here
format long
f=@(x)x^2-3*x+2-exp(x);
f1=@(x)2*x-3-exp(x);
x=0; % ³õÖµ
n=0;
dx=1;

while(abs(dx)>1e-8)
    u=f(x);v=f1(x);
    dx = u/v;
    x = x - dx
    n=n+1;    
end
n
r=x
f(r)

end

