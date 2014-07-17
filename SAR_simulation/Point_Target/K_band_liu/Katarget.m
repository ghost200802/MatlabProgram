%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;clear all;clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%读入参数
sarParam;
%%
%动目标参数
target_num=1;%动目标数
Vgr(1)=0;%动目标地距向速度，方位向速度为0；
Xt(1)=0;%动目标方位向位置；
sigma_t=1.127;%后向反射系数
%%
           
%读取回波
% 回波信号存储矩阵
Sr1_1=zeros(nrn,nan);                                             %初始化通道11存储矩阵
Sr1_2=zeros(nrn,nan);                                             %初始化通道12存储矩阵
Sr1_3=zeros(nrn,nan);                                             %初始化通道13存储矩阵
Sr1_4=zeros(nrn,nan);                                              %初始化通道1存储矩阵
% 读杂波点阵回波原始数据需先运行产生杂波散射的程序
% %读通道11数据
% fid1_1=fopen('airborne_clutter1_1.dat','r+')
% for mm=1:nan
%     data=fread(fid1_1,nrn*2,'float32');
%     data=data(1:2:nrn*2-1)+1i*data(2:2:nrn*2);
%     Sr1_1(:,mm)=data;
% end
% fclose(fid1_1);
% %读通道12数据
% fid1_2=fopen('airborne_clutter1_2.dat','r+')
% for mm=1:nan
%     data=fread(fid1_2,nrn*2,'float32');
%     data=data(1:2:nrn*2-1)+1i*data(2:2:nrn*2);
%     Sr1_2(:,mm)=data;
% end
% fclose(fid1_2);
% %读通道13数据
% fid1_3=fopen('airborne_clutter1_3.dat','r+')
% for mm=1:nan
%     data=fread(fid1_3,nrn*2,'float32');
%     data=data(1:2:nrn*2-1)+1i*data(2:2:nrn*2);
%     Sr1_3(:,mm)=data;
% end
% fclose(fid1_3);
% %读通道14数据
% fid1_4=fopen('airborne_clutter1_4.dat','r+')
% for mm=1:nan
%     data=fread(fid1_4,nrn*2,'float32');
%     data=data(1:2:nrn*2-1)+1i*data(2:2:nrn*2);
%     Sr1_4(:,mm)=data;
% end
% fclose(fid1_4);

%%
% 计算动目标回波数据
for mm=1:target_num
  
        Rst_c=sqrt((azi_position-Xt(mm)).^2+(Rs_gr+Vgr(mm)*ta).^2+H^2);
        Rst_1=sqrt((azi_position-Xt(mm)).^2+(Rs_gr+Vgr(mm)*ta).^2+H^2);
       
        % 发射方位夹角
        Rc=sqrt((Rs_gr+Vgr(mm)*ta).^2+H^2);
        theta_azi_c=atan((Xt(mm)-azi_position)./Rc);
        
        % 距离夹角
        theta_ran=acos(H./Rc)-CenterAngle;
        
        % 接收天线1方位夹角
        theta_azi_1=atan((Xt(mm)-(azi_position))./Rc);
              
        % 天线1回波
        azi_gain1=sinc(La_t/lambda*sin(theta_azi_c)).*sinc(La_r/lambda*sin(theta_azi_1));
        range_gain1=sinc(Lr/lambda*sin(theta_ran)).*sinc(Lr/lambda*sin(theta_ran));
%         position1=round(((Rst_c+Rst_1)/2-Rmin)/delta_R)+1;
%         yushu1=position1-(((Rst_c+Rst_1)/2-Rmin)/delta_R+1);            
%         Sr1(position1:position1+tau_num-1,nn)=Sr1(position1:position1+tau_num-1,nn)+(azi_gain1*range_gain1*sigma_t*St2(1001+round(yushu1*1000):1000:1001+round(yushu1*1000)+1000*(tau_num-1))*exp(-j*2*pi*(Rst_c+Rst_1)/lambda)).';
      %第一列方位向4个孔径回拨
        %距离向设为4个孔径，Lr=0.2;中心视角为33.56
        Razi=Rst_c+Rst_1; 
        theata0=acos(H./Rst_1);
        N=4;
        dn=(-N/2+1:N/2)*Lr;
        detaRange=dn.'*sin(theata0-CenterAngle);
        %孔径1回波
        Tfast=tr.'*ones(1,nan)-ones(nrn,1)*(Razi-detaRange(1,:))/c;
        St2=exp(1i*pi*k*Tfast.^2).*((Tfast>(-tau/2))&(Tfast<(tau/2)));
        Sr1_1=Sr1_1+(ones(nrn,1)*range_gain1).*(sigma_t*St2.*(ones(nrn,1)...
        *(azi_gain1.*exp(-1i*2*pi*Razi/lambda).*exp(2*1i*pi*detaRange(1,:)/lambda))));
        %孔径2回波
        Tfast=tr.'*ones(1,nan)-ones(nrn,1)*(Razi-detaRange(2,:))/c;
        St2=exp(1i*pi*k*Tfast.^2).*((Tfast>(-tau/2))&(Tfast<(tau/2)));
        Sr1_2=Sr1_2+(ones(nrn,1)*range_gain1).*(sigma_t*St2.*(ones(nrn,1)...
        *(azi_gain1.*exp(-1i*2*pi*Razi/lambda).*exp(2*1i*pi*detaRange(2,:)/lambda))));
         %孔径3回波
        Tfast=tr.'*ones(1,nan)-ones(nrn,1)*(Razi-detaRange(3,:))/c;
        St2=exp(1i*pi*k*Tfast.^2).*((Tfast>(-tau/2))&(Tfast<(tau/2)));
        Sr1_3=Sr1_3+(ones(nrn,1)*range_gain1).*(sigma_t*St2.*(ones(nrn,1)...
        *(azi_gain1.*exp(-1i*2*pi*Razi/lambda).*exp(2*1i*pi*detaRange(3,:)/lambda))));
        %孔径4回波
        Tfast=tr.'*ones(1,nan)-ones(nrn,1)*(Razi-detaRange(4,:))/c;
        St2=exp(1i*pi*k*Tfast.^2).*((Tfast>(-tau/2))&(Tfast<(tau/2)));
        Sr1_4=Sr1_4+(ones(nrn,1)*range_gain1).*(sigma_t*St2.*(ones(nrn,1)...
        *(azi_gain1.*exp(-1i*2*pi*Razi/lambda).*exp(2*1i*pi*detaRange(4,:)/lambda))));


end

%%
% 写杂波加动目标回波原始数据
data=zeros(nrn*2,1);
% 写天线11回波数据
fid1_1=fopen('airborne_target1_1.dat','w+');
for mm=1:nan
    data(1:2:nrn*2-1)=real(Sr1_1(:,mm));
    data(2:2:nrn*2)=imag(Sr1_1(:,mm));
    fwrite(fid1_1,data,'float32');
end
fclose(fid1_1);

% 写天线12回波数据
fid1_2=fopen('airborne_target1_2.dat','w+');
for mm=1:nan
    data(1:2:nrn*2-1)=real(Sr1_2(:,mm));
    data(2:2:nrn*2)=imag(Sr1_2(:,mm));
    fwrite(fid1_2,data,'float32');
end
fclose(fid1_2);

% 写天线13回波数据
fid1_3=fopen('airborne_target1_3.dat','w+');
for mm=1:nan
    data(1:2:nrn*2-1)=real(Sr1_3(:,mm));
    data(2:2:nrn*2)=imag(Sr1_3(:,mm));
    fwrite(fid1_3,data,'float32');
end
fclose(fid1_3);

% 写天线14回波数据
fid1_4=fopen('airborne_target1_4.dat','w+');
for mm=1:nan
    data(1:2:nrn*2-1)=real(Sr1_4(:,mm));
    data(2:2:nrn*2)=imag(Sr1_4(:,mm));
    fwrite(fid1_4,data,'float32');
end
fclose(fid1_4);
