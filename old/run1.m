clc;
clear;
close all;

pi=3.1415926;
h=5.14e+5;             %����߶�km
u=3.97206e+014;        %������������
Re=6.37814e+6;         %���������Ϊ���壬����뾶
Rj=h+Re;               %���ص����뾶
we=7.2921158e-5;       %������ת���ٶ�
c=3.0e+8;              %����
f=1.25e+9;             %Ƶ��
lanmda=c/f;            %����
sita=1/8*pi;          %�����ӽ���Ϊ45��
%���������
e=0.001;               %ƫ����
i=deg2rad(96);       %������
domiga=0;              %������ྭΪ��
xomiga=0;              %���ص����Ϊ��
a=Rj/(1-e)             %�볤��
T=sqrt(4*pi^(2)*a^(3)/u);%���ǹ������
n=2*pi/T;               %����ƽ�����ٶ�
t=0:10:T;               %ʱ����
M=n*t;                  %ÿ��ʱ���ĽǶ�
%���ø���Ҷ�任������Ľ�
f=M+e*(2-1/4*e^(2)+5/96*e^(4))*sin(M)+e^(2)*(5/4-11/24*e^(2))*sin(2*M)+e^(3)*(13/12-43/64*e^(2))*sin(3*M)+103/96*e^(4)*sin(4*M)+1097/960*e^(5)*sin(5*M);
[m,n]=size(t);
r=a*(1-e^2)./(1+e*cos(f));                %���ǵ����ĵľ�����ʱ��仯
Ev=[r.*cos(f);r.*sin(f);zeros(size(f))];  %�����ڹ���ϵ�λ��
%����ӹ������ϵ����������ϵ��ת������
Aov1=[cos(domiga),-sin(domiga),0;sin(domiga),cos(domiga),0;0,0,1];
Aov2=[1,0,0;0,cos(i),-sin(i);0,sin(i),cos(i)];
Aov3=[cos(xomiga),-sin(xomiga),0;sin(xomiga),cos(xomiga),0;0,0,1];
Aov=Aov1*Aov2*Aov3;       
Eo=Aov*Ev;                                %�����������ϵ�µ�����
Hg=we*t;                                  %������ת����λ
%����ع�����ϵ������
Eg=[cos(Hg).*Eo(1,:)+sin(Hg).*Eo(2,:);(-1)*sin(Hg).*Eo(1,:)+cos(Hg).*Eo(2,:);Eo(3,:)];
%������Ⱥ�γ��,���ﾭ�ȷֱ�ΪPDF����alpha��γ��Ϊdelta
jingdu=atan(Eg(2,:)./Eg(1,:));
%������Ҫ����
jingduad=[ones(1,floor(n/4)-1)*0,ones(1,ceil(n/4))*pi*(-1),ones(1,floor(n/4)-3)*pi*(-1),ones(1,ceil(n/4)+4)*pi*(-2)];
jingdu=jingdu+jingduad;
jingdu=jingdu*180/pi;
figure;
[x1,y1,z1] = sphere;
surf(x1*Re,y1*Re,z1*Re);  
hold on;
plot3(Eg(1,:),Eg(2,:),Eg(3,:),'r', 'LineWidth',2);
view(-106,4);
figure;
weidu=atan(Eg(3,:)./(sqrt(Eg(1,:).^2+Eg(2,:).^2)));
weidu=weidu*180/pi;
h = geoshow('landareas.shp', 'FaceColor', [1 1 1]);
grid on
hold on
jingdu=mod(jingdu+180,360)-180;
plot(jingdu,weidu,'.');
title('�������µ�켣');
xlabel('���ȣ��ȣ�');ylabel('γ�ȣ��ȣ�');


%���rst��ֵ
ax=1;bx=(-1)*2*(r.^2*cos(2*sita)+Re^2);cx=(Re^2-r.^2).^2;
rst=sqrt(((-1)*bx-sqrt(bx.^2-4*ax.*cx))./(2*ax));

Rs=Eo;             %���������µ����ǵ�����
Vs=sqrt(u/a*(1-e^2))*Aov*[(-1)*sin(f);e+cos(f);zeros(size(f))];%���������µ����ǵ��ٶ�
temp1=(-1)*u*(1+e*cos(f)).^2/(a^2*((1-e^2)^2));
As=Aov*[temp1.*cos(f);temp1.*sin(f);zeros(size(f))]; %���������µ����ǵļ��ٶ�
Aea=[1,0,0;0,cos(sita),sin(sita);0,-sin(sita),cos(sita)];%��������ϵת��Ϊ��������ϵ��ת������
Are=[1,0,0;0,1,0;0,0,1]*[1,0,0;0,1,0;0,0,1]*[1,0,0;0,1,0;0,0,1];%��������ϵת��Ϊ����ƽ̨����ϵ��ת������
gama=atan(e*sin(f)./(1+e*cos(f)));              %������

Ago1=[1,0,0;0,1,0;0,0,1];
Rr=Are*Aea*[zeros(1,n);rst;zeros(1,n)];  
Rv=[(-1)*sin(f-gama).*Rr(1,:)+cos(f-gama).*Rr(2,:);(-1)*cos(f-gama).*Rr(1,:)+(-1).*sin(f-gama).*Rr(2,:);ones(1,n).*Rr(3,:)];
Rt=Ago1*Aov*Rv+Ago1*Rs;            %��������ϵ��Ŀ�������
Vt=[(-1)*we*Rt(2,:);we*Rt(1,:);zeros(size(f))];   %��������ϵ��Ŀ����ٶ�
At=[(-1)*we^2*Rt(1,:);(-1)*we^2*Rt(2,:);zeros(size(f))];%��������ϵ��Ŀ��ļ��ٶ�
%������Ŀ������λ�á��ٶȡ����ٶ�
Rst=Rs-Rt;
Vst=Vs-Vt;
Ast=As-At;

Rstm=sqrt(Rst(1,:).*Rst(1,:)+Rst(2,:).*Rst(2,:)+Rst(3,:).*Rst(3,:));   %������Ŀ�����Ծ���Ĵ�С
fd=2/lanmda.*(Rst(1,:).*Vst(1,:)+Rst(2,:).*Vst(2,:)+Rst(3,:).*Vst(3,:))./Rstm;    %����������Ƶ��
%�����յ�Ƶ��
fr1=(Vst(1,:).*Vst(1,:)+Vst(2,:).*Vst(2,:)+Vst(3,:).*Vst(3,:))./Rstm;
fr2=(Ast(1,:).*Rst(1,:)+Ast(2,:).*Rst(2,:)+Ast(3,:).*Rst(3,:))./Rstm;
fr3=(Vst(1,:).*Rst(1,:)+Vst(2,:).*Rst(2,:)+Vst(3,:).*Rst(3,:)).^2./Rstm.^3;
fr=2/lanmda*(fr1+fr2-fr3);
figure;

plot(weidu,fd);
title('����������Ƶ����γ�ȵĹ�ϵ');
xlabel('γ�ȣ��ȣ�');ylabel('����Ƶ�ʣ�Hz/s��');
figure;

plot(weidu,fr);
title('�����յ�Ƶ����γ�ȵĹ�ϵ');
xlabel('γ�ȣ��ȣ�');ylabel('�����յ�Ƶ�ʣ�Hz/s2��');

