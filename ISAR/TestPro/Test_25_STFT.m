function Test_25
%TEST_25 Summary of this function goes here
%   Detailed explanation goes here
close all

K = 1000;
T = 50;

a =(-K/2:K/2-1)/(K/T);
a = exp(-1i*a.^2);
b = ((-K/2:K/2-1)+K/4)/(K/T);
b = exp(-1i*b.^2);
a = a+b;
plot(real(a))

WindowLength = 101;
w = zeros(1,K);
w(1:WindowLength) = hamming(WindowLength);
w = w/sum(w.^2);
output = zeros(K-WindowLength+1,K);

for m = 0:(K-WindowLength)
    w = circshift(w,[0,1]);
    output(m+1,:) = fft(a.*w);
end

myshow(output)
% 
% [tfr,t,f] = tfrstft(a.');
% 
% tfr = abs(tfr);
% tfr = tfr/max(max(tfr));
% 
% figure,imagesc(t,f,tfr),colormap(gray)



