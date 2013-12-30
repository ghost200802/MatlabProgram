function [ output_signal ] = Rotate2D( input_signal,th,scale )
%2DROTATE Summary of this function goes here
%   Detailed explanation goes here

th = th*pi/180;
[col,row] = size(input_signal);
X = 2*col;
Y = 2*row;

moveX = tan(th/2);
moveY = -sin(th);
dOmegaX = 2*pi/(X*scale);
dOmegaY = 2*pi/(Y/scale);

a = zeros(X,Y);

a(round(0.5*col)+1:round(0.5*col)+col,round(0.5*row)+1:round(0.5*row)+row) = input_signal;
%figure,imagesc(abs(a)/max(max(abs(a)))),colormap(gray);

fft_a1 = fftshift(fft(a.'),1).';
shift1 = exp((-1)*1i*moveX*(-X/2+1:X/2).'*dOmegaY*(-Y/2+1:Y/2));
%figure,imagesc(real(shift1)/max(max(real(shift1)))),colormap(gray);
%figure,imagesc(abs(fft_a1)/max(max(abs(fft_a1)))),colormap(gray);
fft_a1 = fft_a1.*shift1;
%figure,imagesc(abs(fft_a1)/max(max(abs(fft_a1)))),colormap(gray);
b1 = (ifft(fft_a1.')).';
%figure,imagesc(abs(b1)/max(max(abs(b1)))),colormap(gray);


fft_a2 = fftshift(fft(b1),1);
shift2 = exp((-1)*1i*moveY*dOmegaX*(-X/2+1:X/2).'*(-Y/2+1:Y/2));
fft_a2 = fft_a2.*shift2;
b2 = (ifft(fft_a2));
%figure,imagesc(abs(fft_a2)/max(max(abs(fft_a2)))),colormap(gray);
%figure,imagesc(abs(b2)/max(max(abs(b2)))),colormap(gray);

fft_a3 = fftshift(fft(b2.'),1).';
shift1 = exp((-1)*1i*moveX*(-X/2+1:X/2).'*dOmegaY*(-Y/2+1:Y/2));
fft_a3 = fft_a3.*shift1;
b3 = (ifft(fft_a3.')).';
%figure,imagesc(abs(fft_a3)/max(max(abs(fft_a3)))),colormap(gray);
%figure,imagesc(abs(b3)/max(max(abs(b3)))),colormap(gray);

output_signal = b3(round(0.5*col)+1:round(0.5*col)+col,round(0.5*row)+1:round(0.5*row)+row);
%figure,imagesc(abs(output_signal)/max(max(abs(output_signal)))),colormap(gray);

end

