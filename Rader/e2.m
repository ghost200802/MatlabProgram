function  e2
%SAR2 Summary of this function goes here
%   Detailed explanation goes here
num=1000;
m=linspace(0,pi,num);
n=linspace(-pi,pi,num);
r=zeros(num,num);
x=zeros(num,num);
y=zeros(num,num);
z=zeros(num,num);
for i=1:num
    for j=1:num
        r(i,j)=(cos(0.5*pi*sin(n(i))*sin(m(j)))/(sqrt(1-(sin(n(i))*sin(m(j)))^2)))*(sin(3.5*pi*sin(m(j))*cos(n(i)))/sin(0.5*pi*sin(m(j))*cos(n(i))))*(sin(3.5*pi*sin(m(j))*sin(n(i)))/sin(0.5*pi*sin(m(j))*sin(n(i))));
    if r(i,j)<0
        r(i,j)=-r(i,j);
    end
    x(i,j)=r(i,j)*sin(m(j))*cos(n(i));
    y(i,j)=r(i,j)*sin(m(j))*sin(n(i));
    z(i,j)=r(i,j)*cos(m(j));
    end
end;
mesh(x,y,z);
end