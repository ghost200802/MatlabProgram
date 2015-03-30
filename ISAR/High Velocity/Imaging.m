function  Imaging
%IMAGING Summary of this function goes here
%   Detailed explanation goes here
clear all;
clc;



%%
%��ʼ��
beta = 2.5;         %ƥ���˲����ӵĿ��󴰵�ϵ��
%[ F0,F_sample,B,PRF,T_pulse,T_measure,c ] = ParametersSystem();
%[ L0,L_range,Omega,V0,a] = ParametersTarget();
[signal_process,signal_reference] = ReturnSimulate();

myplot(signal_process.');
title('�ز��ź�ͼ');
%%
%������ѹ��
tic
[R_scale A_scale] = size(signal_process);
signal_fft = (FFTY(signal_process));
myplot(signal_fft.');
title('�ز��źŶ�������ͼ');


i_pulselength = length(signal_reference);
%window =  kaiser(i_pulselength,beta);            %���˲������мӴ�����
%signal_reference = signal_reference.*window;
signal_reference_fixed = zeros(1,R_scale);
signal_reference_fixed(1:i_pulselength) = signal_reference;
reference_fft = conj((FFTX(signal_reference_fixed))).';
signal_process = zeros(R_scale,A_scale);
for i = 1:A_scale
    signal_process(:,i) = (signal_fft(:,i).*reference_fft);
end
signal_process = IFFTY(signal_process);
valid_length = R_scale-i_pulselength+1;      %ȥ������������ʹ�õ��ǶԸ����������ķ���������������������������󲿷�
signal_process = signal_process(1:valid_length,:);
[x1,x2] = size(signal_process);
signal_process_f1 = fft(signal_process);
signal_process_f1 = fftshift(signal_process_f1);
myplot(signal_process_f1);
signal_process_f2 = zeros(20*x1,x2);
signal_process_f2(1:x1,:) = signal_process_f1;
signal_process = ifft(signal_process_f2);

figure(5),plot(abs(signal_process.'));
hold on;
figure(6),plot(10*log10(abs(signal_process.')/max(abs(signal_process.'))));
title('����ѹ�����');
toc
end

