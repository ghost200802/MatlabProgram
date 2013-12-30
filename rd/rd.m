clc;clear all;close all;
%%��ֵ����
% tic
cj=sqrt(-1);
C=3e8;  %����
%%�����״����
Fc=1e9; % 1GHz�ز�Ƶ��
lamda=C/Fc;  %����
H=5000;
D=4;
%%Ŀ�귶Χ����
X0=200;  %��λ��[-X0,X0]
Yc=3000;
R01=sqrt(Yc^2+H^2);
%%������(Range),r/t domain
Tr=1.5e-6;%LFM�ź����� 1.5us (200m)
Br=150e6; %LFM�źŴ��� 150MHz
Kr=Br/Tr; %��Ƶб��
Fsr=1.4*Br;
dt=1/Fsr;
V=100;%SARƽ̨�ٶ�
Lsar=300;%�ϳɿ׾�����
Tsar=Lsar/V;%�ϳɿ׾�ʱ��
Nr=512;
Tr_ref=1/Fsr*[-Nr/2:Nr/2-1];
tm=Tr_ref+2*R01/C;


%%��λ��(Azimuth,Cross-Range),x/u domain
Na=512;
Ka=-2*V^2/lamda/R01; %doppler ��Ƶб��
Ba=abs(Ka*Tsar); %doppler ��Ƶ����
PRF=2*Ba;
PRI=1/PRF;
sn=PRI*[-Na/2:Na/2-1];	% slow-time domain��ɢ��

%Ŀ��λ��
Ntar=1;%Ŀ�����
Ptar=[Yc,100,1    
    Yc+50,50,1 
    Yc+50,-50,1
     
       ]; %���������꣬��λ������,sigma  

%%�ֱ���
DY=C/2/Br;  %������ֱ���
DX=D/2;     %��λ��ֱ���

%%========================================================
%%Generate the raw signal data����ԭʼ�ź�����K�������Ŀ��Ļز���������
K=Ntar;           %Ŀ�����
N=Na;            %slow-time domain��������
M=Nr;            %fast-time domain��������
T=Ptar;           %Ŀ��λ��
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
%%Range compression����ѹ��
Refr=exp(j*pi*Kr*Tr_ref.^2).*(-Tr/2<Tr_ref&Tr_ref<Tr/2);
Sr=ifty(fty(Srnm).*(ones(N,1)*conj(fty(Refr))));
Gr=abs(Sr);
figure(2)
colormap(gray);
% imagesc(255-abs(real(Sr)));
mesh(abs(real(Sr)))
R=8;  %sinc???��??
Sr_1=ftx(Sr);
Temp=zeros(N,M);
fn=PRF/Na*[-Na/2:Na/2-1];

%for i=50:450
tic
for i=1:512
        for j=40:450
            
            R0=tm(j)*C/2;
            deta_RCM =lamda^2*R0*fn.^2/(8*V^2);  %?��??��?????
            deta_n=2*deta_RCM/C/dt; %?????????��??��???????
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
