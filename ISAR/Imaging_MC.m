function  Imaging
%IMAGING Summary of this function goes here
%   Detailed explanation goes here
close all;
clear all;
clc;
%%
%��ʼ��
NeedRA = 1;
NeedPC = 1;
NeedKeystone = 1; %need
NeedCRRC = 1; %need
NeedDFTShift = 0;
NeedTFR = 0;

beta = 2.5;         %ƥ���˲����ӵĿ��󴰵�ϵ��
%[ F0,F_sample,B,PRF,T_pulse,T_measure,c ] = ParametersSystem();
%[ L0,L_range,Omega,V0,a] = ParametersTarget();

% ��������
 ReturnSimulate();

load('ReturnSimulate_v0_a0.mat');
% load('ReturnSimulate_9_4dx.mat');

signal_process = signal_return;



% figure,imshow(abs(signal_process.')/max(max(abs(signal_process)))),colormap(gray);
% title('�ز��ź�ͼ');
%%
%������ѹ��
tic
[R_scale A_scale] = size(signal_process);
signal_fft = (FFTY(signal_process));
% figure,imshow(abs((signal_fft).')/max(max(abs(signal_fft)))),colormap(gray);
% title('�ز��źŶ�������ͼ');


i_pulselength = length(signal_reference);
window =  kaiser(i_pulselength,beta);            %���˲������мӴ�����
signal_reference = signal_reference.*window;
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
figure,imagesc(abs(signal_process.')/max(max(abs(signal_process)))),colormap(gray);
title('����ѹ�����');
toc
%%
tic
%Խ���뵥Ԫ�㶯У������λFFT����
%Keystone�㷨
if(NeedKeystone)
    signal_process = Keystone(signal_process);
    %save('signal_process_afterKeystone.mat','signal_process');
    figure,imagesc(abs(signal_process.')/max(max(abs(signal_process)))),colormap(gray);
    title('KeystoneУ�����');
end

[A_scale,R_scale] = size(signal_process);

toc
%%
%�������
if(NeedRA)
    tic
    signal_process = RangeAlignment(signal_process);
    toc
end
%%
%����У��
if(NeedPC)
    signal_process = PhaseCorrection(signal_process);
end

%%
tic
%������λУ��
if(NeedCRRC)
%     [Omega] = calculateRotateSpeed(signal_process)
    Omega = 0.102;
    %Omega = 0.092;
    %Omega = 0.095;
    signal_process = CRRC(signal_process,Omega);
    figure,imagesc(abs(signal_process.')/max(max(abs(signal_process)))),colormap(gray);
    title('CRRCУ�����');
end
toc


signal_process = signal_process.';

[A_scale,R_scale] = size(signal_process);
%%
%�Խ��ٶȱ仯������
if(NeedDFTShift)
    K = 0.045;
    signal_process = DFT(signal_process,K);
else
    signal_process = FFTY(signal_process);
end

if(NeedTFR)
    myshow(signal_process);
    output = zeros(A_scale,R_scale);    
    h_tfr = waitbar(0,'����ʱƵ������');
    for m = 1:A_scale      
        
%         temp = tfrstft(signal_process(:,m));
%         myshow(temp);
%         temp = tfrwv(signal_process(:,m));
%         myshow(temp);
        temp = tfrspwv(signal_process(:,m));
%         myshow(temp);
        
        output(:,m) = temp(:,100);
        waitbar(m/A_scale);
    end    
    close(h_tfr);
    myshow(fftshift(output,1));
end

%%
%��ʾ���
%{
figure
mesh(abs(signal_process));
%}
myshow(signal_process);
title('�������ڰ�ͼ');
end

