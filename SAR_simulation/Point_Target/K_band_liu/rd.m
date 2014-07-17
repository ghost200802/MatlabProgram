%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;clear all;clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�������
sarParam;
%%           
%��ȡ�ز�
% �ز��źŴ洢����
Sr1=zeros(nrn,nan);
%������
fid1=fopen('airborne_target1.dat','r+');
for mm=1:nan
    data=fread(fid1,nrn*2,'float32');
    data=data(1:2:nrn*2-1)+1i*data(2:2:nrn*2);
    Sr1(:,mm)=data;
end
fclose(fid1);

%%
%RD�㷨������ѹ��
Refr=(exp(1i*pi*k*Tr_ref.^2).*(-tau/2<Tr_ref&Tr_ref<tau/2)).';
Sr=iftx(ftx(Sr1).*(conj(ftx(Refr))*ones(1,nan)));
%RCMУ��
Sr=fty(Sr);%�䵽�����������
Rsinc=8;%sinc��ֵ
Sr_temp=zeros(nrn,nan);%��ž���У�����ͼ��
%sinc��ֵ
for lr=30:nrn-70
    R0=tr(lr)*c/2
    deta_RCM=lambda^2*R0*fa.^2/(8*Vs^2);%�����㶯��
    deta_n=2*deta_RCM/c/dtr;%�����㶯��Ӧ���뵥Ԫ
    deta_RCM_n=floor(deta_n);%��������
    deta_RCM_floor=deta_n-deta_RCM_n;%С������
    for la=1:nan
    Sr_temp(lr,la)=sum(Sr(lr+deta_RCM_n(la)-Rsinc/2+1:lr+deta_RCM_n(la)+Rsinc/2,la).'...
        .*sinc(Rsinc/2-1+deta_RCM_floor(la):-1:-Rsinc/2+deta_RCM_floor(la)));
    end
end

%��λ��ѹ��
Refa=exp(-1i*pi*ka*ta.^2).*(abs(ta)<Ts/2);
Sr=ifty(Sr_temp.*(ones(nrn,1)*conj(fty(Refa))));

%%
% дrd�㷨������
data=zeros(nrn*2,1);
% д�ϳɺ�����
fid1=fopen('airborne_target1_afterRD.dat','w+');
for mm=1:nan
    data(1:2:nrn*2-1)=real(Sr(:,mm));
    data(2:2:nrn*2)=imag(Sr(:,mm));
    fwrite(fid1,data,'float32');
end
fclose(fid1);
%%
%��ȡ�ز�
% �ز��źŴ洢����
Sr=zeros(nrn,nan);
%������
fid1=fopen('airborne_target1_afterRD.dat','r+');
for mm=1:nan
    data=fread(fid1,nrn*2,'float32');
    data=data(1:2:nrn*2-1)+1i*data(2:2:nrn*2);
    Sr(:,mm)=data;
end
fclose(fid1);
%�Գ����������ĺ���
N=100;
M=60;
[S,Sdb] = USample2D(Sr,N,M);%SΪ��������㣬SdbΪdBֵ

Point_Analyse_sure(Sr,N,M);