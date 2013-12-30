function Test_15
%TEST_15 Summary of this function goes here
%   Detailed explanation goes here
close all
X = 400;
Y = 400;

a = ones(X,Y);
a(1:2:end,1:2:end)=0;
figure,imshow(a);

a = imrotate(a,45);
figure,imshow(a);

end

