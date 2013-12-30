clc;
clear;
close all;

pi=3.1415926;
h=5.14e+5;             %轨道高度km
u=3.97206e+014;        %地心引力常数
Re=6.37814e+6;         %将地球近似为球体，地球半径
Rj=h+Re;               %近地点轨道半径
we=7.2921158e-5;       %地球自转角速度
c=3.0e+8;              %光速
f=1.25e+9;             %频率
lanmda=c/f;            %波长
sita=1/12*pi;          %天线视角设为30度
%轨道六根数
e=0.001;               %偏心率
i=deg2rad(93);         %轨道倾角
domiga=0;              %升交点赤经为零
xomiga=0;              %近地点幅角为零
a=Rj/(1-e)             %半长轴
T=sqrt(4*pi^(2)*a^(3)/u);%卫星轨道周期
n=2*pi/T;               %卫星平均角速度
t=0:10:T;               %时间跨度
M=n*t;                  %每个时间点的角度
k0=0.9996; %UTM投影比例因子
%利用傅里叶变换求出近心角
f=M+e*(2-1/4*e^(2)+5/96*e^(4))*sin(M)+e^(2)*(5/4-11/24*e^(2))*sin(2*M)+e^(3)*(13/12-43/64*e^(2))*sin(3*M)+103/96*e^(4)*sin(4*M)+1097/960*e^(5)*sin(5*M);
[m,n]=size(t);
r=a*(1-e^2)./(1+e*cos(f));                %卫星到地心的距离随时间变化
Ev=[r.*cos(f);r.*sin(f);zeros(size(f))];  %卫星在轨道上的位置
%求出从轨道坐标系到惯性坐标系的转换矩阵
Aov1=[cos(domiga),-sin(domiga),0;sin(domiga),cos(domiga),0;0,0,1];
Aov2=[1,0,0;0,cos(i),-sin(i);0,sin(i),cos(i)];
Aov3=[cos(xomiga),-sin(xomiga),0;sin(xomiga),cos(xomiga),0;0,0,1];
Aov=Aov1*Aov2*Aov3;       
Eo=Aov*Ev;                                %求出惯性坐标系下的坐标
Hg=we*t;                                  %地球自转的相位
%求出地固坐标系的坐标
Eg=[cos(Hg).*Eo(1,:)+sin(Hg).*Eo(2,:);(-1)*sin(Hg).*Eo(1,:)+cos(Hg).*Eo(2,:);Eo(3,:)];
%求出经度和纬度,这里经度分别为PDF上面alpha，纬度为delta
jingdu=atan(Eg(2,:)./Eg(1,:));
%经度需要修正
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
plot(jingdu,weidu);
title('卫星星下点轨迹');
xlabel('经度（度）');ylabel('纬度（度）');

%求出rst的值
ax=1;bx=(-1)*2*(r.^2*cos(2*sita)+Re^2);cx=(Re^2-r.^2).^2;
rst=sqrt(((-1)*bx-sqrt(bx.^2-4*ax.*cx))./(2*ax));

Rs=Eo;                                                   %卫星的坐标
Vs=sqrt(u/a*(1-e^2))*Aov*[(-1)*sin(f);e+cos(f);zeros(size(f))];%卫星的速度
temp1=(-1)*u*(1+e*cos(f)).^2/(a^2*((1-e^2)^2));
As=Aov*[temp1.*cos(f);temp1.*sin(f);zeros(size(f))];         %卫星的加速度
%天线坐标系转化为星体坐标系的转换矩阵
Aea=[1,0,0;0,cos(sita),sin(sita);0,-sin(sita),cos(sita)]; 
%星体坐标系转化为卫星平台坐标系的转换矩阵
Are=[1,0,0;0,1,0;0,0,1]*[1,0,0;0,1,0;0,0,1]*[1,0,0;0,1,0;0,0,1]; gama=atan(e*sin(f)./(1+e*cos(f)));                          %航迹角
Ago1=[1,0,0;0,1,0;0,0,1];
Rr=Are*Aea*[zeros(1,n);rst;zeros(1,n)];  
Rv=[(-1)*sin(f-gama).*Rr(1,:)+cos(f-gama).*Rr(2,:);(-1)*cos(f-gama).*Rr(1,:)+(-1).*sin(f-gama).*Rr(2,:);ones(1,n).*Rr(3,:)];
Rt=Ago1*Aov*Rv+Ago1*Rs;                       %惯性坐标系下目标的坐标
Vt=[(-1)*we*Rt(2,:);we*Rt(1,:);zeros(size(f))];         %惯性坐标系下目标的速度
At=[(-1)*we^2*Rt(1,:);(-1)*we^2*Rt(2,:);zeros(size(f))];%惯性坐标系下目标的加速度
%卫星与目标的相对位置、速度、加速度
Rst=Rs-Rt;
Vst=Vs-Vt;
Ast=As-At;
%卫星与目标的相对距离的大小
Rstm=sqrt(Rst(1,:).*Rst(1,:)+Rst(2,:).*Rst(2,:)+Rst(3,:).*Rst(3,:));  
%多普勒中心频率
fd=2/lanmda.*(Rst(1,:).*Vst(1,:)+Rst(2,:).*Vst(2,:)+Rst(3,:).*Vst(3,:))./Rstm;    
%多普勒调频率
fr1=(Vst(1,:).*Vst(1,:)+Vst(2,:).*Vst(2,:)+Vst(3,:).*Vst(3,:))./Rstm;
fr2=(Ast(1,:).*Rst(1,:)+Ast(2,:).*Rst(2,:)+Ast(3,:).*Rst(3,:))./Rstm;
fr3=(Vst(1,:).*Rst(1,:)+Vst(2,:).*Rst(2,:)+Vst(3,:).*Rst(3,:)).^2./Rstm.^3;
fr=2/lanmda*(fr1+fr2-fr3);
figure;plot(weidu,fd);
title('多普勒中心频率与纬度的关系');
xlabel('纬度（度）');ylabel('中心频率（Hz/s）');
figure;plot(weidu,fr);
title('多普勒调频率与纬度的关系');
xlabel('纬度（度）');ylabel('多普勒调频率（Hz/s2）');
t=1:10001; %仿真时间
B=weidu; 
L=jingdu; 
n=fix(L/6+1);
L0=6*n-3;                 %计算其所在6度带的中央子午线经度L0
T=(tan(B)).^2;
C=e^2.*(cos(B).^2);
A=(L-L0).*cos(B);
FE=500000;                %东纬偏移 FE= 500000m
FN=10000000;             %北纬偏移 北半球 FN=0，南半球FN=10000000m；
M=a*((1-e^2/4-3*e^4/64-5*e^6/256).*B...
-(3*e^2/8+3*e^4/32+45*e^6/1024).*sin(2*B)...
+(15*e^4/256+45*e^6/1024).*sin(4*B)...
-(35*e^6/3072).*sin(6*B));
N=a./sqrt(1-e^2*(sin(B)).^2);
Xn=k0*(M+N.*tan(B).*((A.^2)/2+(5-T+9.*C+4.*(C.^2)).*(A.^4)/24)+(61-58*T+(T.^2)+270.*C-330.*T.*C).*(A.^6)/720);
Ye=FE+k0.*N.*(A+(1-T+C).*(A.^3)/6+(5-8.*T+T.^2+14.*C-58.*T.*C).*(A.^5)/120);
if (Xn<0)
Xn=FN+Xn;
end
figure
plot(t,Xn,'r-')
hold on
plot(t,Ye,'g-.')
hold off
legend('X-轴分量','Y- 轴分量')
title('星下点轨迹UTM投影图');