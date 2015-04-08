function [ rotateSpeed ] = calculateRotateSpeed( inputSignal )
%CALCULATEROTATESPEED Summary of this function goes here
%   Detailed explanation goes here
%[ ~,~,Omega0,~,~,~] = ParametersTarget();

loopCount = 4;
N = 5;
detOmega = 0.0001;
OmegaShift = 0;

for loop = 1:loopCount
    entropy = zeros(1,2*N+1);

    Omega = (-N:N)*detOmega*(2*N)^(loopCount-loop)+OmegaShift;

    for i = 1:2*N+1
        %i
        currentOmega = Omega(i);
        tempSignal = FFTX(CRRC(inputSignal,currentOmega));
        %myshow(tempSignal)
        tempSignal = abs(tempSignal);
        entropy(i) = sum(tempSignal(tempSignal~=0).*log(tempSignal(tempSignal~=0)));
        %entropy(i) = imageEntropy(tempSignal);
        %entropy(i) = (-1)*imageContrast(tempSignal);
    end
    
    %entropy = entropy/sum(sum(abs(inputSignal)))/10;
    
    figure
    plot(Omega,entropy)
    title('角速度搜索曲线')
    xlabel('转动角速度（rad/s）')
    ylabel('图像熵')

    [~,col] = find(entropy == min(min(entropy)));
    Omega(col(1));

    OmegaShift = Omega(col(1));
end

rotateSpeed = OmegaShift;
%dRotateSpeed = 0.01;