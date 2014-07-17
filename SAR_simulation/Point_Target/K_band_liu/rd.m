%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;clear all;clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%读入参数
sarParam;
%%           
%读取回波
% 回波信号存储矩阵
Sr1=zeros(nrn,nan);
%读数据
fid1=fopen('airborne_target1.dat','r+');
for mm=1:nan
    data=fread(fid1,nrn*2,'float32');
    data=data(1:2:nrn*2-1)+1i*data(2:2:nrn*2);
    Sr1(:,mm)=data;
end
fclose(fid1);

%%
%RD算法距离向压缩
Refr=(exp(1i*pi*k*Tr_ref.^2).*(-tau/2<Tr_ref&Tr_ref<tau/2)).';
Sr=iftx(ftx(Sr1).*(conj(ftx(Refr))*ones(1,nan)));
%RCM校正
Sr=fty(Sr);%变到距离多普勒域
Rsinc=8;%sinc插值
Sr_temp=zeros(nrn,nan);%存放距离校正后的图像
%sinc插值
for lr=30:nrn-70
    R0=tr(lr)*c/2
    deta_RCM=lambda^2*R0*fa.^2/(8*Vs^2);%距离徙动量
    deta_n=2*deta_RCM/c/dtr;%距离徙动对应距离单元
    deta_RCM_n=floor(deta_n);%整数部分
    deta_RCM_floor=deta_n-deta_RCM_n;%小数部分
    for la=1:nan
    Sr_temp(lr,la)=sum(Sr(lr+deta_RCM_n(la)-Rsinc/2+1:lr+deta_RCM_n(la)+Rsinc/2,la).'...
        .*sinc(Rsinc/2-1+deta_RCM_floor(la):-1:-Rsinc/2+deta_RCM_floor(la)));
    end
end

%方位向压缩
Refa=exp(-1i*pi*ka*ta.^2).*(abs(ta)<Ts/2);
Sr=ifty(Sr_temp.*(ones(nrn,1)*conj(fty(Refa))));

%%
% 写rd算法后数据
data=zeros(nrn*2,1);
% 写合成后数据
fid1=fopen('airborne_target1_afterRD.dat','w+');
for mm=1:nan
    data(1:2:nrn*2-1)=real(Sr(:,mm));
    data(2:2:nrn*2)=imag(Sr(:,mm));
    fwrite(fid1,data,'float32');
end
fclose(fid1);
%%
%读取回波
% 回波信号存储矩阵
Sr=zeros(nrn,nan);
%读数据
fid1=fopen('airborne_target1_afterRD.dat','r+');
for mm=1:nan
    data=fread(fid1,nrn*2,'float32');
    data=data(1:2:nrn*2-1)+1i*data(2:2:nrn*2);
    Sr(:,mm)=data;
end
fclose(fid1);
%对成像结果分析的函数
N=100;
M=60;
[S,Sdb] = USample2D(Sr,N,M);%S为升采样后点，Sdb为dB值

Point_Analyse_sure(Sr,N,M);