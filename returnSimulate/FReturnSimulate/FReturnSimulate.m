% function  FReturnSimulate
%FRETURNSIMULATE Summary of this function goes here
%   Detailed explanation goes here
[ Fc,lambda,F_sample,B,F0,PRF,T_pulse,c,H0,th,dth,L0,R0,R_min,R_max,A_min,A_max,Vr,resolutionR,resolutionA ] = parameter();

R_scale = floor((R_max-R_min)/resolutionR);
A_scale = floor((A_max-A_min)/resolutionA);

%%
%对RCS进行傅里叶变换
RCS = zeros(R_scale,A_scale);
RCS(floor(R_scale/2-4):floor(R_scale/2+5),floor(A_scale/2-4):floor(A_scale/2+5)) = inputRCS();
size(RCS)
% myshow(RCS)
phase1 = exp(-1i*4*pi*(1:R_scale)*resolutionR/lambda).'*ones(1,A_scale);
signal = RCS.*phase1;
myshow(signal);
fSignal = fft2(signal);
myshow(fSignal);
%%
%雷达系统的傅里叶变换

f_sizeX = 4*pi/(resolutionA*2);
f_sizeY = 4*pi*B/c;

b = f_sizeY/T_pulse;

f_sizeX = floor(f_sizeX/2)*2;
f_sizeY = floor(f_sizeY/2)*2;

f_sar = zeros(f_sizeX,f_sizeY);

for x = -(f_sizeX/2):f_sizeX/2 
    for y = -(f_sizeY/2):f_sizeY/2  
        f_sar(x+f_sizeX/2+1,y+f_sizeY/2+1) = exp(-1i*(x)/4/b)*exp(-1i*lambda/8/pi*(x.^2/(1+lambda*(y)/4/pi)));
        abs(exp(-1i*(x)/4/b))
        abs(exp(-1i*lambda/8/pi*(x.^2/(1+lambda*(y)/4/pi))))
    end
end

myshow((f_sar))
%%

% end

