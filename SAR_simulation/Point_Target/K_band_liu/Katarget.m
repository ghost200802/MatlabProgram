%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;clear all;clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�������
sarParam;
%%
%��Ŀ�����
target_num=1;%��Ŀ����
Vgr(1)=0;%��Ŀ��ؾ����ٶȣ���λ���ٶ�Ϊ0��
Xt(1)=0;%��Ŀ�귽λ��λ�ã�
sigma_t=1.127;%������ϵ��
%%
           
%��ȡ�ز�
% �ز��źŴ洢����
Sr1_1=zeros(nrn,nan);                                             %��ʼ��ͨ��11�洢����
Sr1_2=zeros(nrn,nan);                                             %��ʼ��ͨ��12�洢����
Sr1_3=zeros(nrn,nan);                                             %��ʼ��ͨ��13�洢����
Sr1_4=zeros(nrn,nan);                                              %��ʼ��ͨ��1�洢����
% ���Ӳ�����ز�ԭʼ�����������в����Ӳ�ɢ��ĳ���
% %��ͨ��11����
% fid1_1=fopen('airborne_clutter1_1.dat','r+')
% for mm=1:nan
%     data=fread(fid1_1,nrn*2,'float32');
%     data=data(1:2:nrn*2-1)+1i*data(2:2:nrn*2);
%     Sr1_1(:,mm)=data;
% end
% fclose(fid1_1);
% %��ͨ��12����
% fid1_2=fopen('airborne_clutter1_2.dat','r+')
% for mm=1:nan
%     data=fread(fid1_2,nrn*2,'float32');
%     data=data(1:2:nrn*2-1)+1i*data(2:2:nrn*2);
%     Sr1_2(:,mm)=data;
% end
% fclose(fid1_2);
% %��ͨ��13����
% fid1_3=fopen('airborne_clutter1_3.dat','r+')
% for mm=1:nan
%     data=fread(fid1_3,nrn*2,'float32');
%     data=data(1:2:nrn*2-1)+1i*data(2:2:nrn*2);
%     Sr1_3(:,mm)=data;
% end
% fclose(fid1_3);
% %��ͨ��14����
% fid1_4=fopen('airborne_clutter1_4.dat','r+')
% for mm=1:nan
%     data=fread(fid1_4,nrn*2,'float32');
%     data=data(1:2:nrn*2-1)+1i*data(2:2:nrn*2);
%     Sr1_4(:,mm)=data;
% end
% fclose(fid1_4);

%%
% ���㶯Ŀ��ز�����
for mm=1:target_num
  
        Rst_c=sqrt((azi_position-Xt(mm)).^2+(Rs_gr+Vgr(mm)*ta).^2+H^2);
        Rst_1=sqrt((azi_position-Xt(mm)).^2+(Rs_gr+Vgr(mm)*ta).^2+H^2);
       
        % ���䷽λ�н�
        Rc=sqrt((Rs_gr+Vgr(mm)*ta).^2+H^2);
        theta_azi_c=atan((Xt(mm)-azi_position)./Rc);
        
        % ����н�
        theta_ran=acos(H./Rc)-CenterAngle;
        
        % ��������1��λ�н�
        theta_azi_1=atan((Xt(mm)-(azi_position))./Rc);
              
        % ����1�ز�
        azi_gain1=sinc(La_t/lambda*sin(theta_azi_c)).*sinc(La_r/lambda*sin(theta_azi_1));
        range_gain1=sinc(Lr/lambda*sin(theta_ran)).*sinc(Lr/lambda*sin(theta_ran));
%         position1=round(((Rst_c+Rst_1)/2-Rmin)/delta_R)+1;
%         yushu1=position1-(((Rst_c+Rst_1)/2-Rmin)/delta_R+1);            
%         Sr1(position1:position1+tau_num-1,nn)=Sr1(position1:position1+tau_num-1,nn)+(azi_gain1*range_gain1*sigma_t*St2(1001+round(yushu1*1000):1000:1001+round(yushu1*1000)+1000*(tau_num-1))*exp(-j*2*pi*(Rst_c+Rst_1)/lambda)).';
      %��һ�з�λ��4���׾��ز�
        %��������Ϊ4���׾���Lr=0.2;�����ӽ�Ϊ33.56
        Razi=Rst_c+Rst_1; 
        theata0=acos(H./Rst_1);
        N=4;
        dn=(-N/2+1:N/2)*Lr;
        detaRange=dn.'*sin(theata0-CenterAngle);
        %�׾�1�ز�
        Tfast=tr.'*ones(1,nan)-ones(nrn,1)*(Razi-detaRange(1,:))/c;
        St2=exp(1i*pi*k*Tfast.^2).*((Tfast>(-tau/2))&(Tfast<(tau/2)));
        Sr1_1=Sr1_1+(ones(nrn,1)*range_gain1).*(sigma_t*St2.*(ones(nrn,1)...
        *(azi_gain1.*exp(-1i*2*pi*Razi/lambda).*exp(2*1i*pi*detaRange(1,:)/lambda))));
        %�׾�2�ز�
        Tfast=tr.'*ones(1,nan)-ones(nrn,1)*(Razi-detaRange(2,:))/c;
        St2=exp(1i*pi*k*Tfast.^2).*((Tfast>(-tau/2))&(Tfast<(tau/2)));
        Sr1_2=Sr1_2+(ones(nrn,1)*range_gain1).*(sigma_t*St2.*(ones(nrn,1)...
        *(azi_gain1.*exp(-1i*2*pi*Razi/lambda).*exp(2*1i*pi*detaRange(2,:)/lambda))));
         %�׾�3�ز�
        Tfast=tr.'*ones(1,nan)-ones(nrn,1)*(Razi-detaRange(3,:))/c;
        St2=exp(1i*pi*k*Tfast.^2).*((Tfast>(-tau/2))&(Tfast<(tau/2)));
        Sr1_3=Sr1_3+(ones(nrn,1)*range_gain1).*(sigma_t*St2.*(ones(nrn,1)...
        *(azi_gain1.*exp(-1i*2*pi*Razi/lambda).*exp(2*1i*pi*detaRange(3,:)/lambda))));
        %�׾�4�ز�
        Tfast=tr.'*ones(1,nan)-ones(nrn,1)*(Razi-detaRange(4,:))/c;
        St2=exp(1i*pi*k*Tfast.^2).*((Tfast>(-tau/2))&(Tfast<(tau/2)));
        Sr1_4=Sr1_4+(ones(nrn,1)*range_gain1).*(sigma_t*St2.*(ones(nrn,1)...
        *(azi_gain1.*exp(-1i*2*pi*Razi/lambda).*exp(2*1i*pi*detaRange(4,:)/lambda))));


end

%%
% д�Ӳ��Ӷ�Ŀ��ز�ԭʼ����
data=zeros(nrn*2,1);
% д����11�ز�����
fid1_1=fopen('airborne_target1_1.dat','w+');
for mm=1:nan
    data(1:2:nrn*2-1)=real(Sr1_1(:,mm));
    data(2:2:nrn*2)=imag(Sr1_1(:,mm));
    fwrite(fid1_1,data,'float32');
end
fclose(fid1_1);

% д����12�ز�����
fid1_2=fopen('airborne_target1_2.dat','w+');
for mm=1:nan
    data(1:2:nrn*2-1)=real(Sr1_2(:,mm));
    data(2:2:nrn*2)=imag(Sr1_2(:,mm));
    fwrite(fid1_2,data,'float32');
end
fclose(fid1_2);

% д����13�ز�����
fid1_3=fopen('airborne_target1_3.dat','w+');
for mm=1:nan
    data(1:2:nrn*2-1)=real(Sr1_3(:,mm));
    data(2:2:nrn*2)=imag(Sr1_3(:,mm));
    fwrite(fid1_3,data,'float32');
end
fclose(fid1_3);

% д����14�ز�����
fid1_4=fopen('airborne_target1_4.dat','w+');
for mm=1:nan
    data(1:2:nrn*2-1)=real(Sr1_4(:,mm));
    data(2:2:nrn*2)=imag(Sr1_4(:,mm));
    fwrite(fid1_4,data,'float32');
end
fclose(fid1_4);
