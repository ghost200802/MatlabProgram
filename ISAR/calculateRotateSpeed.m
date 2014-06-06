function [ rotateSpeed ] = calculateRotateSpeed( inputSignal )
%CALCULATEROTATESPEED Summary of this function goes here
%   Detailed explanation goes here
%[ ~,~,Omega0,~,~,~] = ParametersTarget();


N = 200;
detOmega = 0.001;


entropy = zeros(1,N);

Omega = (1:N)*detOmega;

for i = 1:N
    i
    currentOmega = Omega(i);
    tempSignal = FFTX(CRRC(inputSignal,currentOmega));
    %myshow(tempSignal)
    tempSignal = abs(tempSignal);
    entropy(i) = sum(tempSignal(tempSignal~=0).*log(tempSignal(tempSignal~=0)));
end

figure
plot(Omega,entropy)

[~,col] = find(entropy == min(min(entropy)));
Omega(col);

rotateSpeed = Omega(col);
%rotateSpeed = Omega0;
%dRotateSpeed = 0.01;