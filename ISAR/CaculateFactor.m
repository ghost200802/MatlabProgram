function [K,X] = CaculateFactor( ReferenceSignal,Signal )
%CACULATESTRETCHFACTOR Summary of this function goes here
%   Detailed explanation goes here
StretchLowerRange = 0.9;
StretchUpperRange = 1;
StretchAccuracy = 0.002;

TranslationLowerRange = 0;
TranslationUpperRange = 0;
TranslationAccuracy = 0.1;



Entropy = zeros(((StretchUpperRange-StretchLowerRange)/StretchAccuracy+1),((TranslationUpperRange-TranslationLowerRange)/TranslationAccuracy+1));

%ReferenceSignal = abs(ReferenceSignal);
%ReferenceSignal = ReferenceSignal/sum(sum(ReferenceSignal));
%Signal = abs(Signal);
%Signal = Signal/sum(sum(Signal));

[Col,Row] = size(Signal);

m = 1;

for StretchFactor = StretchLowerRange:StretchAccuracy:StretchUpperRange
    n = 1;
    SignalCaculate = Stretch(Signal,StretchFactor);  
    IFFTSignalCaculate = ifft(SignalCaculate);
    IFFTReferenceSignal = ifft(ReferenceSignal);
    for TranslationFactor = TranslationLowerRange:TranslationAccuracy:TranslationUpperRange
        
        %Shift = exp(-1i*(2*(0:Col-1)*pi*TranslationFactor/Col).'*ones(1,Row));     %相位移动,对第一排相位移动为0
                                                            
        %TranslationSignal = IFFTSignalCaculate.*Shift;
        U = [IFFTReferenceSignal;IFFTSignalCaculate];
        U = fft(U);
        U = abs(U);
        %myshow(U);
        %close;
        Entropy(m,n) = (-1)*sum(U(U~=0).*log(U(U~=0)));          
        n = n+1;
    end
    m = m+1; 
end
%{
for StretchFactor = 1+StretchAccuracy:StretchAccuracy:StretchUpperRange
    n = 1;
    for TranslationFactor = TranslationLowerRange:TranslationAccuracy:TranslationUpperRange
        SignalCaculate = Stretch(Signal,StretchFactor); 
        U = abs(SignalCaculate-ReferenceSignal);
        Entropy(m,n) = sum(sum((U.^2)));
        n = n+1;
    end
    m = m+1;
end
%}

figure,imagesc(Entropy/max(max(Entropy))),colormap(gray);

[col,row] = find(Entropy == max(max(Entropy)));
col = col(1);

row = row(1);
K = StretchLowerRange+(col-1)*StretchAccuracy;
X = TranslationLowerRange+(row-1)*TranslationAccuracy;

end

