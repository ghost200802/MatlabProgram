function  Imaging
%IMAGING Summary of this function goes here
%   Detailed explanation goes here
close all;
clear all;
%%
%��ʼ��
NeedRA = 0;
NeedKeystone = 0;
NeedMTRC = 0;
NeedSRRC = 0;
beta = 2.5;         %ƥ���˲����ӵĿ��󴰵�ϵ��
[ F0,F_sample,B,PRF,T_pulse,T_measure,c ] = ParametersSystem();
tic
[signal_process signal_reference] = ReturnSimulate;
toc
figure,imshow(abs(signal_process)/max(max(abs(signal_process)))),colormap(gray);
title('�ز��ź�ͼ');
%%
%������ѹ��
[R_scale A_scale] = size(signal_process);
signal_fft = (fft(signal_process));
figure,imshow(abs(fftshift(signal_fft,1))/max(max(abs(signal_fft)))),colormap(gray);
title('�ز��źŶ�������ͼ');
i_pulselength = length(signal_reference);
window =  kaiser(i_pulselength,beta);            %���˲������мӴ�����
signal_reference = signal_reference.*window;
signal_reference_fixed = zeros(1,R_scale);
signal_reference_fixed(1:i_pulselength) = signal_reference;
reference_fft = conj((fft(signal_reference_fixed))).';
signal_process = zeros(R_scale,A_scale);
for i = 1:A_scale
    signal_process(:,i) = (signal_fft(:,i).*reference_fft);
end
signal_process = ifft(signal_process);
valid_length = R_scale-i_pulselength+1;      %ȥ������������ʹ�õ��ǶԸ����������ķ���������������������������󲿷�
signal_process = signal_process(1:valid_length,:);     
figure,imagesc(abs(signal_process)/max(max(abs(signal_process)))),colormap(gray);
title('����ѹ�����');
%%
%�������
if(NeedRA)
    tic
    signal_process = RangeAlignment(signal_process);
    toc
end
%%
%����У��
%signal_process = PhaseCorrection(signal_process);
%%
%Խ���뵥Ԫ�㶯У������λFFT����
%Keystone�㷨
if(NeedKeystone)
    signal_process = Keystone(signal_process);
    figure,imagesc(abs(signal_process)/max(max(abs(signal_process)))),colormap(gray);
    title('KeystoneУ�����');
end
%�����Լ�д�ķ���������Щ����
if(NeedSRRC)
    figure,imagesc(abs(signal_process)/max(max(abs(signal_process)))),colormap(gray);
    title('SRRCУ�����');
end
if(NeedMTRC)
    signal_process = MTRC(signal_process);
else
    signal_process = fftshift(fft(signal_process.'),1).';
end
%%
%���ͼ����
output = abs(signal_process)/max(max(abs(signal_process)));
output = output;
%%
%��ʾ���
%{
figure
mesh(output);
%}
figure,contour(output),colormap(jet);  %contour��ͼ���Ϊ���ӵ�ʱ�����ʱ��ǳ�������ͼ����ʱ����
title('����������ͼ');
figure,imagesc(output),colormap(gray),colormap(gray);
title('�������ڰ�ͼ');

testfft = ifftshift(ifft(output),1);
figure,imagesc(real(testfft)),colormap(gray);
end

