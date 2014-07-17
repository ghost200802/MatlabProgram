function imaging_RD
%IMAGE Summary of this function goes here
%   Detailed explanation goes here
clc
close all
clear all

[ Fc,~,~,B,PRF,~,c,H0,L0,~,~,~,~,~,~,Vr ] = ParametersSystem();
beta = 2.5;         %ƥ���˲����ӵĿ��󴰵�ϵ��

[signal_process,signal_reference] = ReturnSimulate();

myshow(real(signal_process));
title('ԭʼ����ʵ��');
%%
%������ѹ��
[A_scale R_scale] = size(signal_process);
signal_fft = (FFTX(signal_process));

i_pulselength = length(signal_reference);
window =  kaiser(i_pulselength,beta);            %���˲������мӴ�����
signal_reference = signal_reference.*window.';
signal_reference_fixed = zeros(1,R_scale);
signal_reference_fixed(1:i_pulselength) = signal_reference;
reference_fft = conj((FFTX(signal_reference_fixed)));
signal_process = zeros(A_scale,R_scale);
for i = 1:A_scale
    signal_process(i,:) = (signal_fft(i,:).*reference_fft);
end
signal_process = IFFTX(signal_process);
valid_length = R_scale-i_pulselength+1;      %ȥ������������ʹ�õ��ǶԸ����������ķ���������������������������󲿷�
signal_process = signal_process(:,1:valid_length);
R_scale = valid_length;
myshow(signal_process);
title('����ѹ�����');
%%
%RCMC
signal_process = FFTY(signal_process);



shiftArray = zeros(1,A_scale);

for i = 1:A_scale
    shift = (-1/8) * (c/Fc)^2 * sqrt(H0^2+L0^2) * (round(i-A_scale/2)/A_scale*PRF)^2 / Vr^2 * 2*B/c;
    shiftArray(i) = shift;
    signal_process(i,:) = circshift(signal_process(i,:),[0,round(shift)]);
    interpPoints = (1:R_scale) - shift + round(shift);
    signal_process(i,:) = interp1(1:R_scale,signal_process(i,:),interpPoints,'spline');
end
%%
%��λ��ѹ��
Ka = 2*Vr^2/(c/Fc)/sqrt(H0^2+L0^2);
Haz = (exp(-1i*pi*(round((1:A_scale)-A_scale/2)/A_scale*PRF).^2/Ka)).' * ones(1,R_scale) ;
signal_process = signal_process .* Haz;
signal_process = IFFTY(signal_process);
myshow(signal_process)
title('��λѹ�����');

%Point_Analyse_sure(signal_process,32,64)
end