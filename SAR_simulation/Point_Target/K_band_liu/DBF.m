%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;clear all;clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�������
sarParam;
 %%          
%��ȡ���׾��ز�
% �ز��źŴ洢����
Sr1_1=zeros(nrn,nan);                                             %��ʼ��ͨ��11�洢����
Sr1_2=zeros(nrn,nan);                                             %��ʼ��ͨ��12�洢����
Sr1_3=zeros(nrn,nan);                                             %��ʼ��ͨ��13�洢����
Sr1_4=zeros(nrn,nan);                                              %��ʼ��ͨ��1�洢����
% ���Ӳ�����ز�ԭʼ�����������в����Ӳ�ɢ��ĳ���
%��ͨ��11����
fid1_1=fopen('airborne_target1_1.dat','r+');
for mm=1:nan
    data=fread(fid1_1,nrn*2,'float32');
    data=data(1:2:nrn*2-1)+1i*data(2:2:nrn*2);
    Sr1_1(:,mm)=data;
end
fclose(fid1_1);
%��ͨ��12����
fid1_2=fopen('airborne_target1_2.dat','r+');
for mm=1:nan
    data=fread(fid1_2,nrn*2,'float32');
    data=data(1:2:nrn*2-1)+1i*data(2:2:nrn*2);
    Sr1_2(:,mm)=data;
end
fclose(fid1_2);
%��ͨ��13����
fid1_3=fopen('airborne_target1_3.dat','r+');
for mm=1:nan
    data=fread(fid1_3,nrn*2,'float32');
    data=data(1:2:nrn*2-1)+1i*data(2:2:nrn*2);
    Sr1_3(:,mm)=data;
end
fclose(fid1_3);
%��ͨ��14����
fid1_4=fopen('airborne_target1_4.dat','r+');
for mm=1:nan
    data=fread(fid1_4,nrn*2,'float32');
    data=data(1:2:nrn*2-1)+1i*data(2:2:nrn*2);
    Sr1_4(:,mm)=data;
end
fclose(fid1_4);
N=4;
dn=(-N/2+1:N/2)*Lr;
%%
%DBF�ϳ�
Rrange=tr*c/2;%������б��
theatar=acos(H./Rrange);%��������б������ӽ�
detaR=dn.'*sin(theatar-CenterAngle);
%���׾���Ȩ����
Sr1_1=Sr1_1.*(exp(-2*1i*pi*detaR(1,:)/lambda).'*ones(1,nan));
Sr1_2=Sr1_2.*(exp(-2*1i*pi*detaR(2,:)/lambda).'*ones(1,nan));
Sr1_3=Sr1_3.*(exp(-2*1i*pi*detaR(3,:)/lambda).'*ones(1,nan));
Sr1_4=Sr1_4.*(exp(-2*1i*pi*detaR(4,:)/lambda).'*ones(1,nan));
%%
%��ʱ�˲�
Sr1_1=ftx(Sr1_1);
Sr1_2=ftx(Sr1_2);
Sr1_3=ftx(Sr1_3);
Sr1_4=ftx(Sr1_4);
t0=2*Rmin/c;
d_alfa0=2*H/c/t0^2/(1-(2*H/c/t0).^2).^(1/2);
wn=exp(1i*2*pi*dn.'*fr*d_alfa0/k/lambda).*exp(-1i*2*pi*dn.'*fr/c);%��ʱ�˲�����
Sr1_1=Sr1_1.*(wn(1,:).'*ones(1,nan));
Sr1_2=Sr1_2.*(wn(2,:).'*ones(1,nan));
Sr1_3=Sr1_3.*(wn(3,:).'*ones(1,nan));
Sr1_4=Sr1_4.*(wn(4,:).'*ones(1,nan));
Sr1_1=iftx(Sr1_1);
Sr1_2=iftx(Sr1_2);
Sr1_3=iftx(Sr1_3);
Sr1_4=iftx(Sr1_4);
%�ϳ�һ·���
Sr1=Sr1_1+Sr1_2+Sr1_3+Sr1_4;
%%
% д�Ӳ��Ӷ�Ŀ��ز����׾��ϳɺ�
data=zeros(nrn*2,1);
% д�ϳɺ�����
fid1=fopen('airborne_target1.dat','w+');
for mm=1:nan
    data(1:2:nrn*2-1)=real(Sr1(:,mm));
    data(2:2:nrn*2)=imag(Sr1(:,mm));
    fwrite(fid1,data,'float32');
end
fclose(fid1);
