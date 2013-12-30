function Azimuth_Compression(PRF)
%AZIMUTH_COMPRESSION Summary of this function goes here
%��λ��ѹ��
%   Detailed explanation goes here

[ Vs,F0,Lamda,H,Br,La,N,daz,c ] = Parameters();

raw_data = Raw_Data(PRF,1);

%data_size = size(raw_data,2);

PRF = 1495;

K=2*Vs^2/Lamda/H/9/PRF^2;               %��Ƶϵ��

L_data = length(raw_data);

i=1:L_data;
i=i-round(L_data/2);

A_filter = exp(j*pi*K*i.^2);            %����ƥ���˲���

f_filter=fft(A_filter);                 %ƥ���˲�
f_data=fft(raw_data);
f_out=f_filter.*f_data;
f_out=fftshift(f_out);

out=abs(fftshift(ifft(f_out)));
out=10*log10(out/max(out));

figure
plot(out)

end

