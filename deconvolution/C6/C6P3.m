function C6P3
%C6P3 Summary of this function goes here
%   Detailed explanation goes here
x0=imread('elephant.bmp');
 figure(1)
 imshow(x0);
 [L1,L2]=size(x0);
 h=ones(3,3)/9;
 y1=conv2(x0,h);
 y=y1(3:L1+2,3:L2+2);
 figure(2)
 imshow(y,[]);
 x=maxentrop(y,h);
 figure(3)
 imshow(x,[]);

end

