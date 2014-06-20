clc;
clear all;
close all;

[ Fc,F0,F_sample,B,PRF,T_pulse,c,H0,L0,L_min,L_max,Bw,~,d_min,d_max,Vr ] = ParametersSystem;

R0 = sqrt(H0^2+L0^2);
Kr = (-1)*B/T_pulse;        %调频率
squint_theta = 0/180.*pi;   %斜视角
lambda = c/Fc;              %波长
fdc = 2*Vr*sin(squint_theta)/lambda;    %多普勒中心频率
squint_min = -Bw/2;
squint_max = Bw/2;
B_dop = 2*(2*sin(Bw/2)/lambda*Vr-fdc);
Ta = R0*(tan(squint_max)-tan(squint_min))/Vr;   %合成孔径时间
%%%%%%%%%%%%%%%%%% calculate the parameters %%%%%%%%%%%%%%%%
% Na=2*ceil(PRF*Ta);               %方位向采样点数可以设置比实际采样点数大一点
% Nr=ceil(F_sample*(T_pulse+(L_max-L_min)/c));    %距离向采样时间窗设置为发射时长加上目标区域的回波时间差


%%%%%%%%%%%%%%%%% generate the raw data %%%%%%%%%%%%%%%%%%
% [target N_target] = Target();
% 
% sig = zeros(Na,Nr);
% h_wait = waitbar(0,'生成数据');
% for i = 1:N_target            %%%假设所有目标都能照射到  
%   for ia = 1:Na
%     target(i,2:3) = target(i,2:3) + target(i,4:5)/PRF    %计算目标的新位置
%     R = sqrt(H0^2+(L0+target(i,2))^2);    %与雷达的距离向距离
%     A = target(i,3);                      %与雷达的方位向距离
%     t_A = A/Vr;
%     th = atan(Vr*(t_A-t_a(ia))/R);
%     Pa = sinc(0.886*th/(Bw/2));
%     if (th >= squint_min && th <= squint_max)
%         range = sqrt(R^2+(Vr*(t_A-t_a(ia)))^2);
%         taud = 2*range/c;
%         phase = -2*pi*F0*taud+pi*Kr*(t_r-taud).^2;
%         sig(ia,:) = sig(ia,:)+target(i,1)*Pa^2*exp(1i*phase).*(abs(t_r-taud) <= T_pulse/2)*(abs(t_a(ia) - target(i,3)) <= Ta/2);
%     end
%      waitbar(((i-1)*Na+ia)/N_target/Na);
%   end 
% end
% close(h_wait);


load('ReturnSimulate.mat');
sig = signal_return;

[Na,Nr] = size(sig);


i_pulselength = length(signal_reference);
Ssc = zeros(1,Na);
Ssc(1:i_pulselength) = signal_reference;


swath = c*Nr/F_sample/2;            %  swath width 
ds = R0*tan(squint_theta)/Vr;      %%%波数中心偏离零多普勒的时间
dly0 = 2*R0/cos(squint_theta)/c;   %场景中心的目标延时

t_a = (-Na/2:Na/2-1)/PRF;
t_r = (-Nr/2:Nr/2-1)/F_sample+dly0 ;          %%%发射脉冲的采样时间点
f_r = (-Nr/2:Nr/2-1)/Nr*F_sample;
f_a = (-Na/2:Na/2-1)/Na*PRF + fdc;




figure;
colormap(gray);
imagesc(real(sig));
title('real part of raw data');

% %%%%%%%%%%%%%%%%%%%%% a_fft %%%%%%%%%%%%%%%%
sig1=fftshift(fft(fftshift(sig)));
% %%%%%%%%%%%%%%%%%%%%% chirp scaling %%%%%%%%%%%%%%%%
R_ref=R0;
f_a=f_a.'*ones(1,Nr);
f_r=ones(Na,1)*f_r;
R0=ones(Na,1)*(t_r*c/2);
D=sqrt(1-(c*f_a/(2*Vr*Fc)).^2);
Dref=sqrt(1-(c*fdc/(2*Vr*Fc)).^2);
P3=R0/Dref;
bulk=R_ref*(1./D-1/Dref);
tao=(2/c)*(P3+bulk);    
tao2=tao-2*R_ref./(c*D);
Z=c*(f_a.^2).*R_ref./(2*Vr^2*Fc^3*D.^3);
Km=Kr./(1-Kr*Z);
alpha=Dref./D-1;

sig2=sig1.*Ssc;
%%%%%%%%%%%%%%%%%%%%% range fft %%%%%%%%%%%%%%%%
sig3=fftshift(fft(fftshift(sig2.'))).';
%%%%%%%%%%%%%%%%%%%%%% range MF and RCMC %%%%%%%%%%%%%%%%
ph1=(1i*pi*D.*f_r.^2./(Km*Dref));
ph2=(1i*4*pi*R_ref*f_r.*alpha/c);
sig4=sig3.*exp(ph1+ph2);
%%%%%%%%%%%%%%%%%%%%% range ifft %%%%%%%%%%%%%%%%
sig5=fftshift(ifft(fftshift(sig4.'))).';
G5=abs(sig5);
figure;
colormap(gray);
imagesc(G5);
title('sig after range MF');
% %%%%%%%%%%%%%%%%%%%%% azimuth MF %%%%%%%%%%%%%%%%
ph3=1i*4*pi*R0*Fc.*D/c;
ph4=-1i*(4*pi*Km/c^2).*(1-D/Dref).*(R0./D-R_ref./D).^2;
sig6=sig5.*exp(ph3+ph4);
% %%%%%%%%%%%%%%%%%%%%% azimuth_ifft %%%%%%%%%%%%%%%%
sig7=fftshift(ifft(fftshift(sig6)));
G7=abs(sig7);
figure;
colormap(gray);
imagesc(G7);
title('sig after azimuth MF');

figure;
plot(abs(sig7(Na/2,:)));
title('one of sig after azimuth MF:range direction');

figure;
plot(abs(sig7(:,Nr/2)));
title('one of sig after azimuth MF:azimuth direction');

clear all



