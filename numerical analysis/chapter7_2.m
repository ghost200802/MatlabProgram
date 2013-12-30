function chapter7_2
%CHAPTER7_2 Summary of this function goes here
%   Detailed explanation goes here

format long
f=@(x)(x^2+2-exp(x))/3;

x=0; % ³õÖµ
n=0;
dx=1;

while(abs(dx)>1e-8)
    u=f(x);
    dx = x-u;
    x = u
    n=n+1;    
end
n
r=x
f(r)

end


