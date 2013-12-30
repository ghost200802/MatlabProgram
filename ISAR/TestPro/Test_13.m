function Test_13
%TEST_13 Summary of this function goes here
%   Detailed explanation goes here
close all;
clear all;
%load('ReturnSimulate.mat');
load('signal_process_afterKeystone.mat');
sig = signal_process.';
figure,plot(real(sig(1,:)));
sig_length = size(sig,2);
T = round(sig_length/4);
b1 = circshift(sig,[0,T]);
b2 = circshift(sig,[0,-T]);
figure,plot(real(b1(1,:)));
figure,plot(real(b2(1,:)));
b = conj(b1).*b2;
figure,plot(real(b(1,:)));
b = b(:,sig_length/2-T+1:sig_length/2+T);
figure,plot(real(b(1,:)));
c = fftshift(fft(b.'),1).';
figure,plot(abs(c(1,:)));
figure,imagesc(abs(c)/max(max(abs(c)))),colormap(gray);
figure,mesh(abs(c)/max(max(abs(c)))),colormap(gray);
end

