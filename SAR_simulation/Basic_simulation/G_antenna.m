function G = G_antenna( th,Ha )
%G_ANTENNA Summary of this function goes here
%À×´ï·½ÏòÍ¼
%Detailed explanation goes here

[R,h,th_antenna,lamda,Ha0]=Parameters();

G=(sinc(pi.*Ha.*sin(th)/lamda)).^2;

end

