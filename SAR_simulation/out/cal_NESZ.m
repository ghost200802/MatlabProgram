%基本参数
H=675e3;           %卫星高度
Re = 6371e3;       %地球半径
Vs=7590;           %平台运动速度
fc=9.6e9;
LF=10^0.3;         %损耗
Laz=10^0.17;
T=290;             %绝对温度值 
K=1.38*10^(-23);   %波尔兹漫常数
c=3e8;  
tr=1.2*10^(-4);    %脉冲间隔
Pt=2e4;            %发射信号功率
Ha=2.923 ;          %天线宽度
La=0.9;            %天线方位向长度
A=Ha*La  ;         %天线面积
bc=c/fc  ;         %波长
G=4*pi*A/(bc^2);   %天线增益
ante_eff=0.85 ;    %天线效率

%计算NESZ    
fid=fopen('beam report06.txt');
i = 1;
NESZ = zeros(1,length(fid));
xaxs = zeros(1,length(fid));
while ~feof(fid)                              %读取所有给定的波束角度、PRF
[dates,count]=fscanf(fid,'%f',3);             %读取给定的角度，及PRF参数
beam_c=dates(1);                              %主瓣波束范围
beam_r=dates(2); 
beam_mid=(beam_c+beam_r)/2;                   %波束中心
PRF=dates(3);                                 %读取给定PRF值 
R0=(H+Re)*cos(beam_mid*pi/180)-sqrt(Re^2-((Re+H)^2)*((beam_mid*pi/180)^2));  %雷达至该点的斜距
if(beam_mid<33)
    Br=6e8;
end
if(beam_mid>=33&beam_mid<43)
    Br=5e8;
end
if(beam_mid>=43)
    Br=4e8;
end

NESZ1=256*(pi^3)*(R0^3)*sin(beam_mid*pi/180)*Vs*Br*K*T*LF*Laz/(Pt*(G^2)*bc^3*tr*PRF*c) %NESZ的计算公式
NESZ(i)=10*log(NESZ1)/log(10);
%plot(beam_mid,NESZ);
%hold on;    
disp(NESZ(i));
xaxs(i) = beam_mid;
i = i+1;
end
plot(xaxs,NESZ);

