%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;clear all;clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%读入参数
sarParam;
%%
% 杂波参数
sigma0=-13;                                                     %地面平均后向散射系数(dB)
sigma0=10^(sigma0/10);
rou_a=0.1;                                                      %方位向分辨率
rou_gr=0.1;                                                     %地距向分辨率
A_valid=rou_a*rou_gr;                                           %地面散射单元的有效面积
num_azi_clutter=round((Ts*Vs)/(25*rou_a));                      %地面方位向杂波点数
if mod(num_azi_clutter,2)==0
    num_azi_clutter=num_azi_clutter+1;                          
end
num_gr_clutter=101;                                             %地面距离向杂波点数
num_clutter=num_azi_clutter*num_gr_clutter;                     %地面杂波点数
num=0;
Xc=zeros(1,num_gr_clutter*num_azi_clutter);
Yc=zeros(1,num_gr_clutter*num_azi_clutter);
for mm=1:num_gr_clutter
   for nn=1:num_azi_clutter
       num=num+1;
       Xc(num)=(nn-1-(num_azi_clutter-1)/2)*(25*rou_a);         %地面杂波点方位向坐标
       Yc(num)=(mm-(num_gr_clutter+1)/2)*rou_gr;                %地面杂波点地距向坐标（相对于中心斜距对应的地距）
   end
end
sigma0=raylrnd(sigma0/sqrt(pi/2),num_clutter,1);                %杂波散射系数（瑞利分布）
sigma=sigma0*A_valid;
save sigma_clutter sigma;
% load sigma_clutter;





%%



% 回波信号存储矩阵
Sr1_1=zeros(nrn,nan);                                             %初始化通道11存储矩阵
Sr1_2=zeros(nrn,nan);                                             %初始化通道12存储矩阵
Sr1_3=zeros(nrn,nan);                                             %初始化通道13存储矩阵
Sr1_4=zeros(nrn,nan);                                             %初始化通道14存储矩阵
% Sr2=zeros(nrn,nan);                                             %初始化通道2存储矩阵
% Sr3=zeros(nrn,nan);                                             %初始化通道3存储矩阵
% Sr4=zeros(nrn,nan);                                             %初始化通道4存储矩阵
% Sr5=zeros(nrn,nan);                                             %初始化通道5存储矩阵
% Sr6=zeros(nrn,nan);                                             %初始化通道6存储矩阵
% 计算杂波回波数据
tic
for mm=1:25:num_clutter

        Rsc_c=sqrt((azi_position-Xc(mm)).^2+(Rs_gr+Yc(mm))^2+H^2);
        Rsc_1=sqrt((azi_position-Xc(mm)).^2+(Rs_gr+Yc(mm))^2+H^2);
        % 发射方位夹角
        Rc=sqrt((Rs_gr+Yc(mm))^2+H^2);
        theta_azi_c=atan((Xc(mm)-azi_position)/Rc);
        % 距离夹角
        theta_ran=acos(H/Rc)-CenterAngle;
        % 接收天线1方位夹角
        theta_azi_1=atan((Xc(mm)-azi_position)./Rc);
       
        % 天线1回波
        azi_gain1=sinc(La_t/lambda*sin(theta_azi_c)).*sinc(La_r/lambda*sin(theta_azi_1));
        range_gain1=sinc(Lr/lambda*sin(theta_ran)).*sinc(Lr/lambda*sin(theta_ran));
%         position1=round(((Rsc_c+Rsc_1)/2-Rmin)/delta_R)+1;
%         yushu1=position1-(((Rsc_c+Rsc_1)/2-Rmin)/delta_R+1);
%%
        %第一列方位向4个孔径回拨
        %距离向设为4个孔径，Lr=0.2;中心视角为33.56
        Razi=Rsc_c+Rsc_1;
        theata0=acos(H./Rsc_1);
        N=4;
        dn=(-N/2+1:N/2)*Lr;
        detaRange=dn.'*sin(theata0-CenterAngle);
        %孔径1回波
        Tfast=tr.'*ones(1,nan)-ones(nrn,1)*(Razi-detaRange(1,:))/c;
        St2=exp(1i*pi*k*Tfast.^2).*((Tfast>(-tau/2))&(Tfast<(tau/2)));
        Sr1_1=Sr1_1+(range_gain1*sigma(mm,1)*St2.*(ones(nrn,1)...
        *(azi_gain1.*exp(-1i*2*pi*Razi/lambda).*exp(2*1i*pi*detaRange(1,:)/lambda))));
        %孔径2回波
        Tfast=tr.'*ones(1,nan)-ones(nrn,1)*(Razi-detaRange(2,:))/c;
        St2=exp(1i*pi*k*Tfast.^2).*((Tfast>(-tau/2))&(Tfast<(tau/2)));
        Sr1_2=Sr1_2+(range_gain1*sigma(mm,1)*St2.*(ones(nrn,1)...
        *(azi_gain1.*exp(-1i*2*pi*Razi/lambda).*exp(2*1i*pi*detaRange(2,:)/lambda))));
        %孔径3回波
        Tfast=tr.'*ones(1,nan)-ones(nrn,1)*(Razi-detaRange(3,:))/c;
        St2=exp(1i*pi*k*Tfast.^2).*((Tfast>(-tau/2))&(Tfast<(tau/2)));
        Sr1_3=Sr1_3+(range_gain1*sigma(mm,1)*St2.*(ones(nrn,1)...
            *(azi_gain1.*exp(-1i*2*pi*Razi/lambda).*exp(2*1i*pi*detaRange(3,:)/lambda))));
        %孔径4回波
        Tfast=tr.'*ones(1,nan)-ones(nrn,1)*(Razi-detaRange(4,:))/c;
        St2=exp(1i*pi*k*Tfast.^2).*((Tfast>(-tau/2))&(Tfast<(tau/2)));
        Sr1_4=Sr1_4+(range_gain1*sigma(mm,1)*St2.*(ones(nrn,1)...
            *(azi_gain1.*exp(-1i*2*pi*Razi/lambda).*exp(2*1i*pi*detaRange(4,:)/lambda))));
      

end
toc

% 写杂波加动目标回波原始数据
data=zeros(nrn*2,1);
% 写天线11回波数据
fid1_1=fopen('airborne_clutter1_1.dat','w+');
for mm=1:nan
    data(1:2:nrn*2-1)=real(Sr1_1(:,mm));
    data(2:2:nrn*2)=imag(Sr1_1(:,mm));
    fwrite(fid1_1,data,'float32');
end
fclose(fid1_1);

% 写天线12回波数据
fid1_2=fopen('airborne_clutter1_2.dat','w+');
for mm=1:nan
    data(1:2:nrn*2-1)=real(Sr1_2(:,mm));
    data(2:2:nrn*2)=imag(Sr1_2(:,mm));
    fwrite(fid1_2,data,'float32');
end
fclose(fid1_2);

% 写天线13回波数据
fid1_3=fopen('airborne_clutter1_3.dat','w+');
for mm=1:nan
    data(1:2:nrn*2-1)=real(Sr1_3(:,mm));
    data(2:2:nrn*2)=imag(Sr1_3(:,mm));
    fwrite(fid1_3,data,'float32');
end
fclose(fid1_3);

% 写天线14回波数据
fid1_4=fopen('airborne_clutter1_4.dat','w+');
for mm=1:nan
    data(1:2:nrn*2-1)=real(Sr1_4(:,mm));
    data(2:2:nrn*2)=imag(Sr1_4(:,mm));
    fwrite(fid1_4,data,'float32');
end
fclose(fid1_4);