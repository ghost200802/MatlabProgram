clc;clear all;close all;
%%恒值参数
% tic
cj=sqrt(-1);
C=3e8;  %光速
%%典型雷达参数
Fc=1e9; % 1GHz载波频率
lamda=C/Fc;  %波长
H=5000;
D=4;
%%目标范围参数
X0=200;  %方位向[-X0,X0]
Yc=3000;
R01=sqrt(Yc^2+H^2);
%%距离向(Range),r/t domain
Tr=1.5e-6;%LFM信号脉宽 1.5us (200m)
Br=150e6; %LFM信号带宽 150MHz
Kr=Br/Tr; %调频斜率
Fsr=1.4*Br;
dt=1/Fsr;
V=100;%SAR平台速度
Lsar=300;%合成孔径长度
Tsar=Lsar/V;%合成孔径时间
Nr=512;
Tr_ref=1/Fsr*[-Nr/2:Nr/2-1];
tm=Tr_ref+2*R01/C;


%%方位向(Azimuth,Cross-Range),x/u domain
Na=512;
Ka=-2*V^2/lamda/R01; %doppler 调频斜率
Ba=abs(Ka*Tsar); %doppler 调频带宽
PRF=2*Ba;
PRI=1/PRF;
sn=PRI*[-Na/2:Na/2-1];	% slow-time domain离散化

%目标位置
Ntar=1;%目标个数
Ptar=[Yc,100,1    
    Yc+50,50,1 
    Yc+50,-50,1
     
       ]; %距离向坐标，方位向坐标,sigma  

%%分辨率
DY=C/2/Br;  %距离向分辨率
DX=D/2;     %方位向分辨率

%%========================================================
%%Generate the raw signal data产生原始信号数据K个理想点目标的回波经采样后
K=Ntar;           %目标个数
N=Na;            %slow-time domain采样个数
M=Nr;            %fast-time domain采样个数
T=Ptar;           %目标位置
Srnm=zeros(N,M);
for k=1:Ntar
    sigma=T(k,3);
    Dslow=sn*V-T(k,2);
    R=sqrt(Dslow.^2+T(k,1)^2+H^2);
    tau=2*R/C;
    Dfast=ones(N,1)*tm-tau'*ones(1,M);
    phase=pi*Kr*Dfast.^2-(4*pi/lamda)*(R'*ones(1,M));
    Srnm=Srnm+sigma*exp(j*phase).*(-Tr/2<Dfast&Dfast<Tr/2).*((abs(Dslow)<Lsar/2)'*ones(1,M));
end
figure
colormap(gray)
imagesc(255-abs(real(Srnm)))
%%========================================================
%%Range compression距离压缩
Refr=exp(j*pi*Kr*Tr_ref.^2).*(-Tr/2<Tr_ref&Tr_ref<Tr/2);
Sr=ifty(fty(Srnm).*(ones(N,1)*conj(fty(Refr))));
Gr=abs(Sr);
figure(2)
colormap(gray);
% imagesc(255-abs(real(Sr)));
mesh(abs(real(Sr)))
R=8;  %sinc???¤??
Sr_1=ftx(Sr);
Temp=zeros(N,M);
fn=PRF/Na*[-Na/2:Na/2-1];

%for i=50:450
tic
for i=1:512
        for j=40:450
            
            R0=tm(j)*C/2;
            deta_RCM =lamda^2*R0*fn.^2/(8*V^2);  %?à??á?????
            deta_n=2*deta_RCM/C/dt; %?????????à??á???????
            deta_n1=deta_n(i);
            Z_n=floor(deta_n1);
            X_n= deta_n1-Z_n;
            Temp(i,j)=sum(Sr_1(i,j+Z_n-R/2+1:j+Z_n+R/2).*sinc((R/2-1+X_n:-1:-R/2+X_n)));
        end
end
toc
Temp_1=iftx(Temp);
figure
colormap(gray);
imagesc(255-abs(Temp_1));


ta=sn;
Refa=exp(cj*pi*Ka*ta.^2).*(abs(ta)<Tsar/2);
Sa=iftx(ftx(Temp_1).*(conj(ftx(Refa)).'*ones(1,M)));
Ga=abs(Sa);

%Sa=iftx(Temp.*(ones(M,1)*exp(-j*pi*fn.^2/Ka)));

figure
colormap(gray);
imagesc(255-abs(Sa));
figure
mesh(Ga)
max(max(Ga))
plot(Ga(:,293))

%%========================================================
