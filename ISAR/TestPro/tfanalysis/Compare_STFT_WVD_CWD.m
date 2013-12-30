%%
%   Topics�� �Ƚ�STFT��WVD��CWD�ֱ��ʺͽ���������
%   Time��   2012-10-21

%%
clear all;close all;

fs = 120;          %������
N = 512;
t = (-N/2+1:1:N/2)/fs;      %����ʱ��
r1 = 3;   f1 = 10;          %��˹���Ƶ�Ƶ�źŲ���
r2 = 4;   f2 = 15;
r3 = 5;   f3 = 20;
r4 = 6;   f4 = 25;
sig1 = (r1/pi)^(1/4)*exp(-r1*t.^2/2+1i*2*pi*f1*t);
sig2 = (r2/pi)^(1/4)*exp(-r2*t.^2/2+1i*2*pi*f2*t);
sig3 = (r3/pi)^(1/4)*exp(-r3*t.^2/2+1i*2*pi*f3*t);
sig4 = (r4/pi)^(1/4)*exp(-r4*t.^2/2+1i*2*pi*f4*t);
sig = [sig1 sig2 sig3 sig4]';
figure;
subplot(2,2,1);
plot(real(sig1));
subplot(2,2,2);
plot(real(sig2));
subplot(2,2,3);
plot(real(sig3));
subplot(2,2,4);
plot(real(sig4));
clear sig1;clear sig2;clear sig3;clear sig4;
figure;plot(1:length(sig),real(sig));
axis([1 2048 -1.2 1.2]);
%�����ʱ����Ҷ�任
w = window(@gausswin,127,0.05); %��˹����sigma = 0.05
[tfr_STFT,t,f]=tfrstft(sig,1:length(sig),512,w);
%ʱƵ��ʾ
figure;
contour(t,f,abs(tfr_STFT));
xlabel('ʱ�� t');
ylabel('Ƶ�� f');

%����Wigner-Ville�ֲ�
[tfr_WVD,t,f]=tfrwv(sig,1:length(sig),512);
%ʱƵ��ʾ
figure;
contour(t,f,abs(tfr_WVD));
xlabel('ʱ�� t');
ylabel('Ƶ�� f');

%����αMargenau-Hill�ֲ�
[tfr_MH,t,f]=tfrpmh(sig,1:length(sig),512);
figure;
contour(t,f,abs(tfr_MH));
xlabel('ʱ�� t');
ylabel('Ƶ�� f');

%����Choi-Williams�ֲ�
[tfr_CW,t,f]=tfrcw(sig,1:length(sig),512);
figure;
contour(t,f,abs(tfr_CW));
xlabel('ʱ�� t');
ylabel('Ƶ�� f');
