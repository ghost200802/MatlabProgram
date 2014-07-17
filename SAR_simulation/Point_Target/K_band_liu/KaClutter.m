%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;clear all;clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�������
sarParam;
%%
% �Ӳ�����
sigma0=-13;                                                     %����ƽ������ɢ��ϵ��(dB)
sigma0=10^(sigma0/10);
rou_a=0.1;                                                      %��λ��ֱ���
rou_gr=0.1;                                                     %�ؾ���ֱ���
A_valid=rou_a*rou_gr;                                           %����ɢ�䵥Ԫ����Ч���
num_azi_clutter=round((Ts*Vs)/(25*rou_a));                      %���淽λ���Ӳ�����
if mod(num_azi_clutter,2)==0
    num_azi_clutter=num_azi_clutter+1;                          
end
num_gr_clutter=101;                                             %����������Ӳ�����
num_clutter=num_azi_clutter*num_gr_clutter;                     %�����Ӳ�����
num=0;
Xc=zeros(1,num_gr_clutter*num_azi_clutter);
Yc=zeros(1,num_gr_clutter*num_azi_clutter);
for mm=1:num_gr_clutter
   for nn=1:num_azi_clutter
       num=num+1;
       Xc(num)=(nn-1-(num_azi_clutter-1)/2)*(25*rou_a);         %�����Ӳ��㷽λ������
       Yc(num)=(mm-(num_gr_clutter+1)/2)*rou_gr;                %�����Ӳ���ؾ������꣨���������б���Ӧ�ĵؾࣩ
   end
end
sigma0=raylrnd(sigma0/sqrt(pi/2),num_clutter,1);                %�Ӳ�ɢ��ϵ���������ֲ���
sigma=sigma0*A_valid;
save sigma_clutter sigma;
% load sigma_clutter;





%%



% �ز��źŴ洢����
Sr1_1=zeros(nrn,nan);                                             %��ʼ��ͨ��11�洢����
Sr1_2=zeros(nrn,nan);                                             %��ʼ��ͨ��12�洢����
Sr1_3=zeros(nrn,nan);                                             %��ʼ��ͨ��13�洢����
Sr1_4=zeros(nrn,nan);                                             %��ʼ��ͨ��14�洢����
% Sr2=zeros(nrn,nan);                                             %��ʼ��ͨ��2�洢����
% Sr3=zeros(nrn,nan);                                             %��ʼ��ͨ��3�洢����
% Sr4=zeros(nrn,nan);                                             %��ʼ��ͨ��4�洢����
% Sr5=zeros(nrn,nan);                                             %��ʼ��ͨ��5�洢����
% Sr6=zeros(nrn,nan);                                             %��ʼ��ͨ��6�洢����
% �����Ӳ��ز�����
tic
for mm=1:25:num_clutter

        Rsc_c=sqrt((azi_position-Xc(mm)).^2+(Rs_gr+Yc(mm))^2+H^2);
        Rsc_1=sqrt((azi_position-Xc(mm)).^2+(Rs_gr+Yc(mm))^2+H^2);
        % ���䷽λ�н�
        Rc=sqrt((Rs_gr+Yc(mm))^2+H^2);
        theta_azi_c=atan((Xc(mm)-azi_position)/Rc);
        % ����н�
        theta_ran=acos(H/Rc)-CenterAngle;
        % ��������1��λ�н�
        theta_azi_1=atan((Xc(mm)-azi_position)./Rc);
       
        % ����1�ز�
        azi_gain1=sinc(La_t/lambda*sin(theta_azi_c)).*sinc(La_r/lambda*sin(theta_azi_1));
        range_gain1=sinc(Lr/lambda*sin(theta_ran)).*sinc(Lr/lambda*sin(theta_ran));
%         position1=round(((Rsc_c+Rsc_1)/2-Rmin)/delta_R)+1;
%         yushu1=position1-(((Rsc_c+Rsc_1)/2-Rmin)/delta_R+1);
%%
        %��һ�з�λ��4���׾��ز�
        %��������Ϊ4���׾���Lr=0.2;�����ӽ�Ϊ33.56
        Razi=Rsc_c+Rsc_1;
        theata0=acos(H./Rsc_1);
        N=4;
        dn=(-N/2+1:N/2)*Lr;
        detaRange=dn.'*sin(theata0-CenterAngle);
        %�׾�1�ز�
        Tfast=tr.'*ones(1,nan)-ones(nrn,1)*(Razi-detaRange(1,:))/c;
        St2=exp(1i*pi*k*Tfast.^2).*((Tfast>(-tau/2))&(Tfast<(tau/2)));
        Sr1_1=Sr1_1+(range_gain1*sigma(mm,1)*St2.*(ones(nrn,1)...
        *(azi_gain1.*exp(-1i*2*pi*Razi/lambda).*exp(2*1i*pi*detaRange(1,:)/lambda))));
        %�׾�2�ز�
        Tfast=tr.'*ones(1,nan)-ones(nrn,1)*(Razi-detaRange(2,:))/c;
        St2=exp(1i*pi*k*Tfast.^2).*((Tfast>(-tau/2))&(Tfast<(tau/2)));
        Sr1_2=Sr1_2+(range_gain1*sigma(mm,1)*St2.*(ones(nrn,1)...
        *(azi_gain1.*exp(-1i*2*pi*Razi/lambda).*exp(2*1i*pi*detaRange(2,:)/lambda))));
        %�׾�3�ز�
        Tfast=tr.'*ones(1,nan)-ones(nrn,1)*(Razi-detaRange(3,:))/c;
        St2=exp(1i*pi*k*Tfast.^2).*((Tfast>(-tau/2))&(Tfast<(tau/2)));
        Sr1_3=Sr1_3+(range_gain1*sigma(mm,1)*St2.*(ones(nrn,1)...
            *(azi_gain1.*exp(-1i*2*pi*Razi/lambda).*exp(2*1i*pi*detaRange(3,:)/lambda))));
        %�׾�4�ز�
        Tfast=tr.'*ones(1,nan)-ones(nrn,1)*(Razi-detaRange(4,:))/c;
        St2=exp(1i*pi*k*Tfast.^2).*((Tfast>(-tau/2))&(Tfast<(tau/2)));
        Sr1_4=Sr1_4+(range_gain1*sigma(mm,1)*St2.*(ones(nrn,1)...
            *(azi_gain1.*exp(-1i*2*pi*Razi/lambda).*exp(2*1i*pi*detaRange(4,:)/lambda))));
      

end
toc

% д�Ӳ��Ӷ�Ŀ��ز�ԭʼ����
data=zeros(nrn*2,1);
% д����11�ز�����
fid1_1=fopen('airborne_clutter1_1.dat','w+');
for mm=1:nan
    data(1:2:nrn*2-1)=real(Sr1_1(:,mm));
    data(2:2:nrn*2)=imag(Sr1_1(:,mm));
    fwrite(fid1_1,data,'float32');
end
fclose(fid1_1);

% д����12�ز�����
fid1_2=fopen('airborne_clutter1_2.dat','w+');
for mm=1:nan
    data(1:2:nrn*2-1)=real(Sr1_2(:,mm));
    data(2:2:nrn*2)=imag(Sr1_2(:,mm));
    fwrite(fid1_2,data,'float32');
end
fclose(fid1_2);

% д����13�ز�����
fid1_3=fopen('airborne_clutter1_3.dat','w+');
for mm=1:nan
    data(1:2:nrn*2-1)=real(Sr1_3(:,mm));
    data(2:2:nrn*2)=imag(Sr1_3(:,mm));
    fwrite(fid1_3,data,'float32');
end
fclose(fid1_3);

% д����14�ز�����
fid1_4=fopen('airborne_clutter1_4.dat','w+');
for mm=1:nan
    data(1:2:nrn*2-1)=real(Sr1_4(:,mm));
    data(2:2:nrn*2)=imag(Sr1_4(:,mm));
    fwrite(fid1_4,data,'float32');
end
fclose(fid1_4);