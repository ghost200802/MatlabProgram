function  C5P7
%C5P7 Summary of this function goes here
%   Detailed explanation goes here
close all
clear all

A = zeros(16,16);
B = zeros(32,32);

A(1:4,1:4) = ones(4,4);
%A(9:16,9:16) = ones(8,8);
figure
imshow(A)

B(1:8,1:8) = ones(8,8);
%B(1:8,17:24) = ones(8,8);

%B(9:16,9:16) = ones(8,8);
B(9:16,25:32) = ones(8,8);

B(17:24,1:8) = ones(8,8);
%B(17:24,17:24) = ones(8,8);

%B(25:32,9:16) = ones(8,8);
B(25:32,25:32) = ones(8,8);

figure
imshow(B)

C = conv2(A,B);
figure
imshow(C)

C1=C+max(max(C))/10*randn(size(C))
figure
imshow(C1)

[B1,A1] = Ayers_Dainty(C,B,A,10);
figure
imshow(A1);
figure
imshow(B1);

[B2,A2] = Ayers_Dainty(C1,B,A,10);
figure
imshow(A2);
figure
imshow(B2);
%{
[B2,A2] = SA(C,B,A);
figure
imshow(A2);
figure
imshow(B2);
%}
end

