function 3P4
%3-4 Summary of this function goes here
%   Detailed explanation goes here

N = 4;

A = 0.5*rand(N,N);
A = A+A';

%A = rand(N,N);

%{
for i = 1:N
    A(i,i)=N-1+rand(1,1);
end
%}
x = rand(N,1);
b = A*x;

am = max(diag(A));
beta = 0;
xh = zeros(N,1);
r=b;
p=1/am*b;
for i = 1:N
    p = 1/am*r+beta*p;
    alpha = 1/am*(r'*r)/(p'*A*p);
    xh = xh+alpha*p;
    r0 = r;
    r = r0-alpha*A*p;
    beta = r'*r/(r0'*r0);
end

x
xh



end

