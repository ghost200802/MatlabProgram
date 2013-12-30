function  Test_14
%TEST_14 Summary of this function goes here
%   Detailed explanation goes here
close all;
clear all;
clc;

th = 10;
th = th*pi/180;
Move = 1;
X = 400;
Y = 400;

moveX = tan(th/2);
moveY = -sin(th);

core_a = zeros(100,100);
core_a(1:10:end,1:10:end)=1;
a = zeros(X,Y);
dOmegaX = 2*pi/X;
dOmegaY = 2*pi/Y;
a(151:250,151:250) = core_a;
figure,imagesc(abs(a)/max(max(abs(a)))),colormap(gray);


fft_a1 = fftshift(fft(a.'),1).';
%fft_a1 = fftshift(fft2(a));
%shift1 = exp((-1)*1i*moveX*(-X/2+1:X/2).'*dOmegaY*(-Y/2+1:Y/2));
%shift1 = exp((-1)*1i*moveX*(-X/2+1:X/2).'*ones(1,Y));
shift1 = exp((-1)*1i*moveX*ones(1,X).'*(-Y/2+1:Y/2)*10);
%figure,imagesc(real(shift1)/max(max(real(shift1)))),colormap(gray);
%figure,imagesc(abs(fft_a1)/max(max(abs(fft_a1)))),colormap(gray);
fft_a1 = fft_a1.*shift1;
%figure,imagesc(abs(fft_a1)/max(max(abs(fft_a1)))),colormap(gray);
b1 = (ifft(fft_a1.')).';
figure,imagesc(abs(b1)/max(max(abs(b1)))),colormap(gray);
%{

fft_a2 = fftshift(fft(b1),1);
shift2 = exp((-1)*1i*moveY*dOmegaX*(-X/2+1:X/2).'*(-Y/2+1:Y/2));
fft_a2 = fft_a2.*shift2;
b2 = (ifft(fft_a2));
figure,imagesc(abs(fft_a2)/max(max(abs(fft_a2)))),colormap(gray);
figure,imagesc(abs(b2)/max(max(abs(b2)))),colormap(gray);

fft_a3 = fftshift(fft(b2.'),1).';
shift1 = exp((-1)*1i*moveX*(-X/2+1:X/2).'*dOmegaY*(-Y/2+1:Y/2));
fft_a3 = fft_a3.*shift1;
b3 = (ifft(fft_a3.')).';
figure,imagesc(abs(fft_a3)/max(max(abs(fft_a3)))),colormap(gray);
figure,imagesc(abs(b3)/max(max(abs(b3)))),colormap(gray);
%}
end

