function SubAperture_simple
%SUBAPERTURE_SIMPLE Summary of this function goes here
%   Detailed explanation goes here
clc
close all
clear all

load('ImagingResult.mat');
aperture1 = signal_process1;
aperture2 = signal_process2;
aperture3 = signal_process3;
aperture4 = signal_process4;

K_final = zeros(1,4);
K_final(1) = 1;

combinedAperture = aperture1;
%%
tic
K0 = 1;
dK = 0.1;
N = 10;
K = K0 + (-N:N)*dK/N;

%%

entropy = zeros(1,2*N+1);

for i = 1:2*N+1
    %i
    currentK = K(i);
    tempAperture2 = Stretch(aperture2,currentK);
    tempOutput = [IFFTY(combinedAperture);IFFTY(tempAperture2)];
    tempOutput = abs(FFTY(tempOutput));
    %myshow(tempOutput)
    entropy(i) = sum(tempOutput(tempOutput~=0).*log(tempOutput(tempOutput~=0)));
end

figure
plot(K,entropy)
[~,col] = find(entropy == min(min(entropy)));

K_final(2) = K(min(col));

aperture2 = Stretch(aperture2,K_final(2));

combinedAperture = [IFFTY(combinedAperture);IFFTY(aperture2)];
combinedAperture = (FFTY(combinedAperture));
myshow(combinedAperture)

%%

entropy = zeros(1,2*N+1);

for i = 1:2*N+1
    %i
    currentK = K(i);
    tempAperture3 = Stretch(aperture3,currentK);
    tempOutput = [IFFTY(combinedAperture);IFFTY(tempAperture3)];
    tempOutput = abs(FFTY(tempOutput));
    %myshow(tempOutput)
    entropy(i) = sum(tempOutput(tempOutput~=0).*log(tempOutput(tempOutput~=0)));
end

figure
plot(K,entropy)
[~,col] = find(entropy == min(min(entropy)));

K_final(3) = K(min(col));

aperture3 = Stretch(aperture3,K_final(3));

combinedAperture = [IFFTY(combinedAperture);IFFTY(aperture3)];
combinedAperture = (FFTY(combinedAperture));
myshow(combinedAperture)

%%

entropy = zeros(1,2*N+1);

for i = 1:2*N+1
    %i
    currentK = K(i);
    tempAperture4 = Stretch(aperture4,currentK);
    tempOutput = [IFFTY(combinedAperture);IFFTY(tempAperture4)];
    tempOutput = abs(FFTY(tempOutput));
    %myshow(tempOutput)
    entropy(i) = sum(tempOutput(tempOutput~=0).*log(tempOutput(tempOutput~=0)));
end

figure
plot(K,entropy)
[~,col] = find(entropy == min(min(entropy)));

K_final(4) = K(min(col));


aperture4 = Stretch(aperture4,K_final(4));

toc
tic

combinedAperture = [IFFTY(combinedAperture);IFFTY(aperture4)];
combinedAperture = (FFTY(combinedAperture));
myshow(combinedAperture)
toc
% %%
% 
% entropy = zeros(1,2*N+1);
% 
% for i = 1:2*N+1
%     %i
%     currentK = K(i);
%     tempAperture5 = Stretch(aperture5,currentK);
%     tempOutput = [IFFTY(combinedAperture);IFFTY(tempAperture5)];
%     tempOutput = abs(FFTY(tempOutput));
%     %myshow(tempOutput)
%     entropy(i) = sum(tempOutput(tempOutput~=0).*log(tempOutput(tempOutput~=0)));
% end
% 
% figure
% plot(K,entropy)
% [~,col] = find(entropy == min(min(entropy)));
% 
% K_final(5) = K(min(col));
% 
% aperture5 = Stretch(aperture5,K_final(5));
% 
% combinedAperture = [IFFTY(combinedAperture);IFFTY(aperture5)];
% combinedAperture = (FFTY(combinedAperture));
% myshow(combinedAperture)
%%
K_final

%%
% for i = 1:100
%     K = 

% aperture1 = Stretch(aperture1,strechFactor(1));
% aperture2 = Stretch(aperture2,strechFactor(2));
% aperture3 = Stretch(aperture3,strechFactor(3));
% aperture4 = Stretch(aperture4,strechFactor(4));
% 
% ifft_1 = IFFTY(aperture1);
% ifft_2 = IFFTY(aperture2);
% ifft_3 = IFFTY(aperture3);
% ifft_4 = IFFTY(aperture4);
% 
% R = 1068;
% [A1,~] = size(ifft_1);
% [A2,~] = size(ifft_2);
% [A3,~] = size(ifft_3);
% 
% for i = 1:R
%     ifft_2(:,R) = ifft_2(:,R)*ifft_1(A1,R);
% end
% 
% for i = 1:R
%     ifft_3(:,R) = ifft_3(:,R)*ifft_2(A2,R);
% end
% 
% for i = 1:R
%     ifft_4(:,R) = ifft_4(:,R)*ifft_3(A2,R);
% end
% 
% myshow(aperture1)
% myshow(aperture2)
% myshow(aperture3)
% myshow(aperture4)
% 
% % myshow(ifft_1)
% % myshow(ifft_2)
% % myshow(ifft_3)
% %myshow(ifft_4)
% 
% addAll = [ifft_1;ifft_2;ifft_3];
% % myshow(addAll)
% output = FFTY(addAll);
% output = abs(output);
% %output = (output>(0.2*max(max(output)))).*output;
% myshow(output)
% figure
% contour(output);


end

