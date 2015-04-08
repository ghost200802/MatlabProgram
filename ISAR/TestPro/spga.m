clc;
clear all;
close all;
j = sqrt(-1);
R0 = 20E3;%          scene center nearest range [m]
Vr = 150;%           effective velocity  [m/sec]
Tr = 2.5E-6;%                pulse duration  [sec]
Kr = -20E12;%         range chirp rate [Hz/sec]
f0 = 5.3E9;%         carrrier frequency [Hz]
Fr = 60E6;%          range sampling frequency [Hz]
Fa = 100;%           pulse repetition frequency [Hz]
squint_theta = 0/180.*pi;%squint angle;%
c=3e8;
lambda = c/f0;%              wave length
B_dop = double(80.0);%       Doppler bandwidth

fdc = 2*Vr*sin(squint_theta)/lambda;% Doppler centroid frequency
squint_min = asin((fdc-B_dop/2)/2./Vr*lambda);  
squint_max = asin((fdc+B_dop/2)/2./Vr*lambda);% calculate the azimuth wave angular bandwidth 
Ta = R0*(tan(squint_max)-tan(squint_min))/Vr;%   synthetic aperture time
%%%%%%%%%%%%%%%%%% calculate the parameters %%%%%%%%%%%%%%%%
Na=2*ceil(Fa*Ta);               %方位向采样点数可以设置比实际采样点数大一点
Nr=2*ceil(Fr*(Tr));                     %距离向采样时间窗可以设置为发射脉冲时宽的两倍
swath = c*Nr/Fr/2;%                swath width 
ds = R0*tan(squint_theta)/Vr;      %%%波数中心偏离零多普勒的时间
dly0 = 2*R0/cos(squint_theta)/c;   %场景中心的目标延时
t_a = (-Na/2:Na/2-1)/Fa;
t_r = (-Nr/2:Nr/2-1)/Fr+dly0 ;          %%%发射脉冲的采样时间点
f_r = (-Nr/2:Nr/2-1)/Nr*Fr;
f_a = (-Na/2:Na/2-1)/Na*Fa + fdc;
%%%%%%%%%%%%%%%%% generate the raw data %%%%%%%%%%%%%%%%%%
N_target =3; 
P_target = [R0,0;R0+swath/4,0;R0-swath/4,0]; %[目标到航迹的最近斜距，方位向时间]
factor=1/200000*sin(4*pi*t_a/Ta)+1/400000*sin(3*pi*t_a/Ta)+1; %相位误差因子，代表航迹的偏离程度
sig = zeros(Na,Nr);
for i = 1:N_target            %%%假设所有目标都能照射到
  for ia = 1:Na 
    range = sqrt(P_target(i,1)^2+(Vr*(t_a(ia)-P_target(i,2)))^2);
    range = range * factor(ia);
    taud = 2*range/c;
    phase = -2*pi*f0*taud+pi*Kr*(t_r-taud).^2;
    sig(ia,:) = sig(ia,:)+exp(1i*phase).*(abs(t_r-taud) <= Tr/2)*(abs(t_a(ia) - P_target(i,2)) <= Ta/2);
  end
end

figure;
colormap(gray);
imagesc(real(sig));
title('real part of raw data');

%=================加入指定形式的相位误差================
Ka=-2*Vr^2/lambda/R0;   
err=exp(-1i*pi*Ka/20*(t_a).^2-1i*pi*Ka/30*(t_a).^4-1i*pi*Ka/50*(t_a).^5);
%err=exp(-1i*pi*Ka/10*(t_a).^2);
sig_dis=sig.*(err.'*ones(1,Nr));%
figure;
colormap(gray);
imagesc(real(sig_dis));
title('加相位误差后的数据');

% %%%%%%%%%%%%%%%%%%%%% a_fft %%%%%%%%%%%%%%%%
sig1=fftshift(fft(fftshift(sig_dis)));
% %%%%%%%%%%%%%%%%%%%%% chirp scaling %%%%%%%%%%%%%%%%
R_ref=R0;
f_a=f_a.'*ones(1,Nr);
f_r=ones(Na,1)*f_r;
R0=ones(Na,1)*(t_r*c/2);

D=sqrt(1-(c*f_a/(2*Vr*f0)).^2);
Dref=sqrt(1-(c*fdc/(2*Vr*f0)).^2);
P3=R0/Dref;
bulk=R_ref*(1./D-1/Dref);
tao=(2/c)*(P3+bulk);
tao2=tao-2*R_ref./(c*D);
Z=c*(f_a.^2).*R_ref./(2*Vr^2*f0^3*D.^3);
Km=Kr./(1-Kr*Z);

alpha=Dref./D-1;
Ssc=exp(1i*pi*Kr.*alpha.*(tao2.^2));

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
ph3=1i*4*pi*R0*f0.*D/c;
ph4=-1i*(4*pi*Km/c^2).*(1-D/Dref).*(R0./D-R_ref./D);
sig6=sig5.*exp(ph3+ph4);
% %%%%%%%%%%%%%%%%%%%%% azimuth_ifft %%%%%%%%%%%%%%%%
sig7=fftshift(ifft(fftshift(sig6)));
G7=abs(sig7);
figure;
colormap(gray);
imagesc(G7);
title('foucused signal BF PGA');

% %%%%%%%%%%%%%%%%%%%%% azimuth_ifft %%%%%%%%%%%%%%%%
sig_pga=fftshift(ifft(fftshift(sig5)));

count = 0;
while(count<20)
    count = count+1;
        %=============取距离压缩后的中间方位向数据，解斜============
        win_size = Na;
        win = zeros(1,Na);
        win(Na/2-win_size/2+1:Na/2+win_size/2) = 1;

        sig_ph=sig_pga(:,Nr/2+1).';
        Ka=-2*Vr^2/lambda/R_ref;   
        de=exp(-1i*pi*Ka*(t_a).^2);
        sig_de = sig_ph.*de;

        sig_de = sig_de.*win;
        %============ACCC====================
        sig_detla=zeros(1,Na-1);
        for n=1:Na-1
              sig_detla(n)=conj(sig_de(n))*sig_de(n+1);
        end
        sig_detla=angle(sig_detla);

        %=============误差估计=================
        phase=zeros(1,Na);
            for i=1:Na-1
                phase(i+1)=sum(sig_detla(1:i));
            end
        %================补偿相位误差=======================
        sig_pga=sig_pga.*(exp(-1i*phase).'*ones(1,Nr));
end

sig5=fftshift(fft(fftshift(sig_pga)));
% %%%%%%%%%%%%%%%%%%%%% azimuth MF %%%%%%%%%%%%%%%%
ph3=1i*4*pi*R0*f0.*D/c;
ph4=-1i*(4*pi*Km/c^2).*(1-D/Dref).*(R0./D-R_ref./D);
sig6=sig5.*exp(ph3+ph4);
% %%%%%%%%%%%%%%%%%%%%% azimuth_ifft %%%%%%%%%%%%%%%%
sig7=fftshift(ifft(fftshift(sig6)));
G7=abs(sig7);
figure;
colormap(gray);
imagesc(G7);
title('foucused signal BF PGA');

