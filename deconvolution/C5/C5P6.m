function C5P6
x0=[1,2,3;4,5,6;7,8,9];
h0=3*rand(2,2);
y=conv2(x0,h0);
x0=[1.1,1.9,3.1;4.2,5.3,6.2;7.1,8.2,9.1];
[x,h]=Ayers_Dainty(y,x0,h0,100)

end

