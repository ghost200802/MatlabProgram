 %%          
%读取各孔径回波
% 回波信号存储矩阵
Sr1_1=zeros(nrn,nan);                                             %初始化通道11存储矩阵
Sr1_2=zeros(nrn,nan);                                             %初始化通道12存储矩阵
Sr1_3=zeros(nrn,nan);                                             %初始化通道13存储矩阵
Sr1_4=zeros(nrn,nan);                                              %初始化通道1存储矩阵
% 读杂波点阵回波原始数据需先运行产生杂波散射的程序
%读通道11数据
fid1_1=fopen('airborne_target1_1.dat','r+');
for mm=1:nan
    data=fread(fid1_1,nrn*2,'float32');
    data=data(1:2:nrn*2-1)+1i*data(2:2:nrn*2);
    Sr1_1(:,mm)=data;
end
fclose(fid1_1);
%读通道12数据
fid1_2=fopen('airborne_target1_2.dat','r+');
for mm=1:nan
    data=fread(fid1_2,nrn*2,'float32');
    data=data(1:2:nrn*2-1)+1i*data(2:2:nrn*2);
    Sr1_2(:,mm)=data;
end
fclose(fid1_2);
%读通道13数据
fid1_3=fopen('airborne_target1_3.dat','r+');
for mm=1:nan
    data=fread(fid1_3,nrn*2,'float32');
    data=data(1:2:nrn*2-1)+1i*data(2:2:nrn*2);
    Sr1_3(:,mm)=data;
end
fclose(fid1_3);
%读通道14数据
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