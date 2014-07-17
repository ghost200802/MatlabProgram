function imaging_CS
%IMAGE Summary of this function goes here
%   Detailed explanation goes here

clc;
clear all;
close all;

beta = 2.5;         %匹配滤波所加的凯泽窗的系数

[ Fc,F0,F_sample,B,PRF,T_pulse,c,H0,L0,L_min,L_max,Bw,~,d_min,d_max,Vr,dx ] = ParametersSystem;

R0 = sqrt(H0^2+L0^2);
Kr = (-1)*B/T_pulse;        %调频率
squint_theta = 0/180.*pi;   %斜视角
lambda = c/Fc;              %波长

i_pulselength = T_pulse*F_sample;
fdc = 2*Vr*sin(squint_theta)/lambda;    %多普勒中心频率
squint_min = -Bw/2;
squint_max = Bw/2;
Ta = (d_max-d_min)/Vr;   %合成孔径时间
%%
%计算参数
A_scale=ceil(PRF*Ta);                                %方位向采样点数
R_scale=ceil(F_sample*(T_pulse+2*(L_max-L_min)/c));    %距离向采样时间窗设置为发射时长加上目标区域的回波时间差
dly0 = 2*R0/cos(squint_theta)/c;   %场景中心的目标延时
t_a = (1:A_scale)/PRF;
t_r = (-R_scale/2:R_scale/2-1)/F_sample+dly0 ;          %发射脉冲的采样时间点
f_r = (-R_scale/2:R_scale/2-1)/R_scale*F_sample;
f_a = (-A_scale/2:A_scale/2-1)/A_scale*PRF + fdc;
%%
%生成回波数据
[target N_target] = Target();

sig = zeros(A_scale,R_scale);
h_wait = waitbar(0,'生成数据');
for i = 1:N_target            %%%假设所有目标都能照射到
  for ia = 1:A_scale
    target(i,2:3) = target(i,2:3) + target(i,4:5)/PRF;    %计算目标的新位置
    R = sqrt(H0^2+(L0+target(i,2))^2);          %与雷达的距离向距离
    A1 = target(i,3)-d_min;                      %与雷达的方位向距离
    t_A1 = A1/Vr;
    A2 = target(i,3)-d_min - dx;
    t_A2 = A2/Vr;
    th = atan(Vr*(t_A1-t_a(ia))/R);             %因为孔径比较近，所以只选取了其中一个进行限制角度的计算
    Pa = sinc(pi/2*th/(Bw));
    if (th >= squint_min && th <= squint_max)            
        range1 = sqrt(R^2+(Vr*(t_A1-t_a(ia)))^2);       %由于雷达的干涉基线造成发射与接收的距离不同
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
title('原始数据实部');
%%
%CS处理
%方位向FFT
sig=fftshift(fft(fftshift(sig)));
%参数计算
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

%距离向匹配滤波
Ssc=exp(1i*pi*Kr.*alpha.*(tao2.^2));        
window =  kaiser(R_scale,beta);            %对滤波器进行加窗处理
window = (window * ones(1,A_scale)).';
sig=sig.*Ssc;
%距离向FFT
sig=fftshift(fft(fftshift(sig.'))).';

%距离向MF以及RCMC
ph1=(1i*pi*D.*f_r.^2./(Km*Dref));
ph2=(1i*4*pi*R_ref*f_r.*alpha/c);
sig=sig.*exp(ph1+ph2);

%距离向IFFT
sig=fftshift(ifft(fftshift(sig.'))).';
myshow(real(sig))
title('测试');

%去除弃置区
valid_length = R_scale-i_pulselength+1;      %去除弃置区，因使用的是频域生成回波的方法，所以弃置区在数据区的中心部分
valid_left = floor((R_scale-valid_length)/2);
valid_right = valid_left+valid_length;
sig = sig(:,valid_left:valid_right);
R0 = R0(:,valid_left:valid_right);
D = D(:,valid_left:valid_right);
Km = Km(:,valid_left:valid_right);
% R_scale = valid_length;
myshow(sig)
title('距离压缩结果');

%%
%方位向MF
ph3=1i*4*pi*R0*Fc.*D/c;
ph4=-1i*(4*pi*Km/c^2).*(1-D/Dref).*(R0./D-R_ref./D).^2;
sig=sig.*exp(ph3+ph4);

%方位IFFT
sig=fftshift(ifft(fftshift(sig)));
myshow(sig)
title('方位压缩结果');

%Point_Analyse_sure(sig,32,32)

