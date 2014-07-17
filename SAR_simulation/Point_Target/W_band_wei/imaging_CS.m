function imaging_CS
%IMAGE Summary of this function goes here
%   Detailed explanation goes here

clc;
clear all;
close all;

beta = 2.5;         %ƥ���˲����ӵĿ��󴰵�ϵ��

[ Fc,F0,F_sample,B,PRF,T_pulse,c,H0,L0,L_min,L_max,Bw,~,d_min,d_max,Vr,dx ] = ParametersSystem;

R0 = sqrt(H0^2+L0^2);
Kr = (-1)*B/T_pulse;        %��Ƶ��
squint_theta = 0/180.*pi;   %б�ӽ�
lambda = c/Fc;              %����

i_pulselength = T_pulse*F_sample;
fdc = 2*Vr*sin(squint_theta)/lambda;    %����������Ƶ��
squint_min = -Bw/2;
squint_max = Bw/2;
Ta = (d_max-d_min)/Vr;   %�ϳɿ׾�ʱ��
%%
%�������
A_scale=ceil(PRF*Ta);                                %��λ���������
R_scale=ceil(F_sample*(T_pulse+2*(L_max-L_min)/c));    %���������ʱ�䴰����Ϊ����ʱ������Ŀ������Ļز�ʱ���
dly0 = 2*R0/cos(squint_theta)/c;   %�������ĵ�Ŀ����ʱ
t_a = (1:A_scale)/PRF;
t_r = (-R_scale/2:R_scale/2-1)/F_sample+dly0 ;          %��������Ĳ���ʱ���
f_r = (-R_scale/2:R_scale/2-1)/R_scale*F_sample;
f_a = (-A_scale/2:A_scale/2-1)/A_scale*PRF + fdc;
%%
%���ɻز�����
[target N_target] = Target();

sig = zeros(A_scale,R_scale);
h_wait = waitbar(0,'��������');
for i = 1:N_target            %%%��������Ŀ�궼�����䵽
  for ia = 1:A_scale
    target(i,2:3) = target(i,2:3) + target(i,4:5)/PRF;    %����Ŀ�����λ��
    R = sqrt(H0^2+(L0+target(i,2))^2);          %���״�ľ��������
    A1 = target(i,3)-d_min;                      %���״�ķ�λ�����
    t_A1 = A1/Vr;
    A2 = target(i,3)-d_min - dx;
    t_A2 = A2/Vr;
    th = atan(Vr*(t_A1-t_a(ia))/R);             %��Ϊ�׾��ȽϽ�������ֻѡȡ������һ���������ƽǶȵļ���
    Pa = sinc(pi/2*th/(Bw));
    if (th >= squint_min && th <= squint_max)            
        range1 = sqrt(R^2+(Vr*(t_A1-t_a(ia)))^2);       %�����״�ĸ��������ɷ�������յľ��벻ͬ
        range2 = sqrt(R^2+(Vr*(t_A2-t_a(ia)))^2);
        taud = (range1+range2)/c;
        phase = -2*pi*F0*taud+pi*Kr*(t_r-taud).^2;
        sig(ia,:) = sig(ia,:)+target(i,1)*Pa^2*exp(1i*phase).*(abs(t_r-taud) <= T_pulse/2)*(abs(t_a(ia) - t_A1) <= Ta/2);
    end    
    waitbar(((i-1)*A_scale+ia)/N_target/A_scale);
  end
end
close(h_wait);

myshow(real(sig));
title('ԭʼ����ʵ��');
%%
%CS����
%��λ��FFT
sig=fftshift(fft(fftshift(sig)));
%��������
R_ref=R0;
f_a=f_a.'*ones(1,R_scale);
f_r=ones(A_scale,1)*f_r;
R0=ones(A_scale,1)*(t_r*c/2);
D=sqrt(1-(c*f_a/(2*Vr*Fc)).^2);
Dref=sqrt(1-(c*fdc/(2*Vr*Fc)).^2);
P3=R0/Dref;
bulk=R_ref*(1./D-1/Dref);
tao=(2/c)*(P3+bulk);   
tao2=tao-2*R_ref./(c*D);
Z=c*(f_a.^2).*R_ref./(2*Vr^2*Fc^3*D.^3);
Km=Kr./(1-Kr*Z);
alpha=Dref./D-1;

%������ƥ���˲�
Ssc=exp(1i*pi*Kr.*alpha.*(tao2.^2));        
window =  kaiser(R_scale,beta);            %���˲������мӴ�����
window = (window * ones(1,A_scale)).';
sig=sig.*Ssc;
%������FFT
sig=fftshift(fft(fftshift(sig.'))).';

%������MF�Լ�RCMC
ph1=(1i*pi*D.*f_r.^2./(Km*Dref));
ph2=(1i*4*pi*R_ref*f_r.*alpha/c);
sig=sig.*exp(ph1+ph2);

%������IFFT
sig=fftshift(ifft(fftshift(sig.'))).';
myshow(real(sig))
title('����');

%ȥ��������
valid_length = R_scale-i_pulselength+1;      %ȥ������������ʹ�õ���Ƶ�����ɻز��ķ����������������������������Ĳ���
valid_left = floor((R_scale-valid_length)/2);
valid_right = valid_left+valid_length;
sig = sig(:,valid_left:valid_right);
R0 = R0(:,valid_left:valid_right);
D = D(:,valid_left:valid_right);
Km = Km(:,valid_left:valid_right);
% R_scale = valid_length;
myshow(sig)
title('����ѹ�����');

%%
%��λ��MF
ph3=1i*4*pi*R0*Fc.*D/c;
ph4=-1i*(4*pi*Km/c^2).*(1-D/Dref).*(R0./D-R_ref./D).^2;
sig=sig.*exp(ph3+ph4);

%��λIFFT
sig=fftshift(ifft(fftshift(sig)));
myshow(sig)
title('��λѹ�����');

%Point_Analyse_sure(sig,32,32)

