function pulse_azimuth = Pulse_Azimuth( x,x0,Target )
%PULSE_AZIMUTH Summary of this function goes here
%ģ�ⷽλ��һ��������Ľ��
%   Detailed explanation goes here

[ Vs,F0,H,Br,PRF,N,daz,c ] = Parameters();

Lamda = c/Br;

pulse_azimuth = exp(-j*2*pi/Lamda.*(sqrt(H^2+(x-Target).^2)+sqrt(H^2+(x0-Target).^2)));


end

