function  SubAperture
%SUBAPERTURE Summary of this function goes here
%   Detailed explanation goes here
close all;
clear all;
clc;

N_Aperture = 4;

load('ImagingResult.mat');
figure,imagesc(abs(signal_process)/max(max(abs(signal_process)))),colormap(gray);
[Col,Row] = size(signal_process);
ifft_signal_process = IFFTY(signal_process);


ApertureLength = ceil(Col/N_Aperture);
LastMismatch = N_Aperture*ApertureLength-Col;
MismatchLeft = floor(LastMismatch/2);
MismatchRight = ApertureLength-(LastMismatch-MismatchLeft);


signal_output = zeros(0,Row);
signal_process = zeros(ApertureLength,Row,N_Aperture);

for m = 1:N_Aperture
    if(m~=N_Aperture)
        signal_process(:,:,m) = FFTY(ifft_signal_process((m-1)*ApertureLength+1:m*ApertureLength,:));
    else
        signal_process(MismatchLeft+1:MismatchRight,:,m) = FFTY(ifft_signal_process((m-1)*ApertureLength+1:end,:));
        signal_process(:,:,m) = Stretch(signal_process(:,:,m),(ApertureLength/(ApertureLength-LastMismatch)));
    end
end

K = ones(1,N_Aperture);
X = zeros(1,N_Aperture);



%{
for m = 2:N_Aperture
    %K(m) = 1+(2*m-1)*K0;
    [K(m),X(m)] = CaculateFactor(signal_process(:,:,1),signal_process(:,:,m));
end
%}

K0 = 0.0125;
X0 = 0;
for m = 1:N_Aperture
   K(m) = 1/(1+K0*(2*m-1)); 
   X(m) = (m-1)*X0;
end



for m = 1:N_Aperture    
    SignalStretched = Stretch(signal_process(:,:,m),K(m));
    
    figure,imagesc(abs(SignalStretched)/max(max(abs(SignalStretched)))),colormap(gray);
    
    IFFTSignalCaculate = IFFTY(SignalStretched);

    %Shift = exp(-1i*(2*(0:ApertureLength-1)*pi*X(m)/ApertureLength).'*ones(1,Row));     %相位移动,对第一排相位移动为0
                                                            
    %TranslationSignal = IFFTSignalCaculate.*Shift;
    
    %figure,imagesc(abs(FFTY(TranslationSignal))/max(max(abs(FFTY(TranslationSignal))))),colormap(gray);
    
    %signal_output = [signal_output;TranslationSignal];
    signal_output = [signal_output;IFFTSignalCaculate];
end

signal_output = FFTY(signal_output);
signal_output = abs(signal_output)/max(max(abs(signal_output)));
figure,contour(signal_output),colormap(jet);

%signal_output = signal_output.*(signal_output>0.5);
myshow(signal_output);
K
X

end

