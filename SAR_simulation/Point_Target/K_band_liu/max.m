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
a=max([max(max(abs(Sr1_1))),max(max(abs(Sr1_2))),max(max(abs(Sr1_3))),max(max(abs(Sr1_4)))]);
% S1=floor(abs(Sr1_1)/a*255);
% S2=floor(abs(Sr1_2)/a*255);
% S3=floor(abs(Sr1_3)/a*255);
% S4=floor(abs(Sr1_4)/a*255);
S1=abs(Sr1_1)/a;
S2=abs(Sr1_2)/a;
S3=abs(Sr1_3)/a;
S4=abs(Sr1_4)/a;