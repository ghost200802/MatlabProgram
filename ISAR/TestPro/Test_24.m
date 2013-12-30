function Test_24
%TEST_24 Summary of this function goes here
%   Detailed explanation goes here
close all
load('ImagingResult.mat');
%signal_process = zeros(10,10);
%signal_process(3:8,:) = ones(6,10);
myshow(signal_process);
tic
signal_process = IFFTY(signal_process);
toc
myshow(signal_process);

for k = 0.051
    tic
    U = DFT(signal_process,k);
    toc
    U = abs(U)/max(max(abs(U)));
    (-1)*sum(U(U~=0).*log(U(U~=0)))
    myshow(U);    
end



end

