function Test_19
%TEST_19 Summary of this function goes here
%   Detailed explanation goes here

a = rand(1,10)+1i*rand(1,10);
xa = 1:10;

figure,plot(real(a));
figure,plot(imag(a));
figure,plot(abs(a));

b = 0:0.1:10;

c1 = spline(xa,real(a),b);
c2 = spline(xa,imag(a),b);
figure,plot(c1);
figure,plot(c2);

end

