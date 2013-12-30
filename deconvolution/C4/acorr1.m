function r = acorr1( x )
%ACORR1 Summary of this function goes here
%   Detailed explanation goes here
N=length(x);
r=zeros(1,N);
for i=1:N
    for n=1:N-i
        r(i)=r(i)+x(n)*x(n+i);
    end
    r(i)=r(i)/(N-i+1);
end

end

