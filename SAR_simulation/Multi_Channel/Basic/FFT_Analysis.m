function FFT_Analysis( PRF )
%FFT_ANALYSIS Summary of this function goes here
%ÐÅºÅÆµÆ×·ÖÎö
%   Detailed explanation goes here

raw_data = Raw_Data(PRF,1);
f_data = fft(raw_data);
f_data = fftshift(f_data);

figure
plot(abs((f_data)))

end

