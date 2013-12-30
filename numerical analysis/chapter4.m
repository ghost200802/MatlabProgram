function chapter4
%CHAPTER4 Summary of this function goes here
%   Detailed explanation goes here

n_max=100;
e1=zeros(1,n_max);
e2=zeros(1,n_max);

for n=1:n_max
    
    h=1/n;

    x1=h:h:1;
    x2=h/2:h:1+h/2;
    f1 = [0 sqrt(x1).*log(x1)];
    f2 = sqrt(x2).*log(x2);

    X1=(2*(sum(f1)-f1(1)-f1(end))+f1(1)+f1(end))*h/2;
    X2=(4*(sum(f2)-f2(end))+2*(sum(f1)-f1(1)-f1(end))+f1(1)+f1(end))*h/6;

    e1(n)=abs(-4/9-X1);
    e2(n)=abs(-4/9-X2);
end

x=1:n_max;
plot(x,e1,'red');
hold on
plot(x,e2,'black');
end

