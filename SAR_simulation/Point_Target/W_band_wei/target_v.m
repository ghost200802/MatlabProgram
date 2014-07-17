clc
clear
close all

sita = 25;      %雷达安装俯角，单位°
deta_fi = 5;    %距离向波束宽度，单位°
z = 500;        %平台飞行高度，单位米
x_start  = z/tand(sita+deta_fi/2)   %距离向测绘带起始距离
x_center = z/tand(sita)             %距离向测绘带中心距离
x_end    = z/tand(sita-deta_fi/2)   %距离向测绘带结束距离
x_band   = x_end-x_start            %距离向测绘带
 

%% 目标1坐标及速度设定,目标径向速度指向雷达
x(1,1) = 970;      %目标距离向位置
y(1,1) = 5;        %目标方位向位置
if (x(1,1)<x_start||x(1,1)>x_end)
    '指定目标位置超出距离向测绘带！'
    return;
end
el(1,1) = atand(z/(x(1,1)^2+y(1,1)^2)^0.5);     %目标实际俯仰角

vr(1,1) = -0.1;            %目标径向速度
sita_ground(1,1) = 45;    %设定目标相对地面以南偏西sita_ground°运动
v_ground(1,1) = vr(1,1)/cosd(90-atand(y(1,1)/x(1,1))-sita_ground(1,1))/cosd(el(1,1)); %目标相对于地面的运动速度大小，方向为相对地面以南偏西sita_ground°
v_x(1,1) = v_ground(1,1)*sind(sita_ground(1,1));        %目标距离向分速度，指向靠近雷达方向
v_y(1,1) = v_ground(1,1)*cosd(sita_ground(1,1));        %目标方位向分速度，指向靠近雷达方向


%% 目标2坐标及速度设定，目标径向速度指向雷达
x(1,2) = 990;       %目标距离向位置
y(1,2) = 15;        %目标方位向位置
if (x(1,2)<x_start||x(1,2)>x_end)
    '指定目标位置超出距离向测绘带！'
    return;
end
el(1,2) = atand(z/(x(1,2)^2+y(1,2)^2)^0.5);     %目标实际俯仰角

vr(1,2) = -6;              %目标径向速度
sita_ground(1,2) = 60;    %设定目标相对地面以南偏西sita_ground°运动
v_ground(1,2) = vr(1,2)/cosd(90-atand(y(1,2)/x(1,2))-sita_ground(1,2))/cosd(el(1,2)); %目标相对于地面的运动速度大小，方向为相对地面以南偏西sita_ground°
v_x(1,2) = v_ground(1,2)*sind(sita_ground(1,2));        %目标距离向分速度，指向靠近雷达方向
v_y(1,2) = v_ground(1,2)*cosd(sita_ground(1,2));        %目标方位向分速度，指向靠近雷达方向

%% 目标3坐标及速度设定
x(1,3) = 1000;       %目标距离向位置
y(1,3) = 10;         %目标方位向位置
if (x(1,3)<x_start||x(1,3)>x_end)
    '指定目标位置超出距离向测绘带！'
    return;
end
el(1,3) = atand(z/(x(1,3)^2+y(1,3)^2)^0.5);     %目标实际俯仰角

vr(1,3) = 5;              %目标径向速度
sita_ground(1,3) = 60;    %设定目标相对地面以南偏东sita_ground°运动
v_ground(1,3) = vr(1,3)/cosd(180-atand(x(1,3)/y(1,3))-sita_ground(1,3))/cosd(el(1,3)); %目标相对于地面的运动速度大小，方向为相对地面以南偏东sita_ground°
v_x(1,3) = v_ground(1,3)*sind(sita_ground(1,3));        %目标距离向分速度
v_y(1,3) = v_ground(1,3)*cosd(sita_ground(1,3));        %目标方位向分速度

%% 目标4坐标及速度设定
x(1,4) = 1010;       %目标距离向位置
y(1,4) = 20;         %目标方位向位置
if (x(1,4)<x_start||x(1,4)>x_end)
    '指定目标位置超出距离向测绘带！'
    return;
end
el(1,4) = atand(z/(x(1,4)^2+y(1,4)^2)^0.5);     %目标实际俯仰角

vr(1,4) = 30;             %目标径向速度
sita_ground(1,4) = 70;    %设定目标相对地面以南偏东sita_ground°运动
v_ground(1,4) = vr(1,4)/cosd(180-atand(x(1,4)/y(1,4))-sita_ground(1,4))/cosd(el(1,4)); %目标相对于地面的运动速度大小，方向为相对地面以南偏东sita_ground°
v_x(1,4) = v_ground(1,4)*sind(sita_ground(1,4));        %目标距离向分速度
v_y(1,4) = v_ground(1,4)*cosd(sita_ground(1,4));        %目标方位向分速度

%% 目标5坐标及速度设定,下半平面目标
x(1,5) = 1070;       %目标距离向位置
y(1,5) = 10;         %目标方位向位置
if (x(1,5)<x_start||x(1,5)>x_end)
    '指定目标位置超出距离向测绘带！'
    return;
end
el(1,5) = atand(z/(x(1,5)^2+y(1,5)^2)^0.5);     %目标实际俯仰角

vr(1,5) = -46;             %目标径向速度
sita_ground(1,5) = 30;    %设定目标相对地面以北偏西sita_ground°运动
v_ground(1,5) = vr(1,5)/cosd(atand(x(1,5)/y(1,5))-sita_ground(1,5))/cosd(el(1,5)); %目标相对于地面的运动速度大小，方向为相对地面以北偏西sita_ground°
v_x(1,5) = v_ground(1,5)*sind(sita_ground(1,5));        %目标距离向分速度
v_y(1,5) = v_ground(1,5)*cosd(sita_ground(1,5));        %目标方位向分速度

%% 目标6坐标及速度设定,下半平面目标
x(1,6) = 1100;       %目标距离向位置
y(1,6) = 40;         %目标方位向位置
if (x(1,6)<x_start||x(1,6)>x_end)
    '指定目标位置超出距离向测绘带！'
    return;
end
el(1,6) = atand(z/(x(1,6)^2+y(1,6)^2)^0.5);     %目标实际俯仰角

vr(1,6) = -70;             %目标径向速度
sita_ground(1,6) = 40;    %设定目标相对地面以北偏西sita_ground°运动
v_ground(1,6) = vr(1,6)/cosd(atand(x(1,6)/y(1,6))-sita_ground(1,6))/cosd(el(1,6)); %目标相对于地面的运动速度大小，方向为相对地面以北偏西sita_ground°
v_x(1,6) = v_ground(1,6)*sind(sita_ground(1,6));        %目标距离向分速度
v_y(1,6) = v_ground(1,6)*cosd(sita_ground(1,6));        %目标方位向分速度

%% 目标7坐标及速度设定,下半平面目标
x(1,7) = 1190;       %目标距离向位置
y(1,7) = 90;         %目标方位向位置
if (x(1,7)<x_start||x(1,7)>x_end)
    '指定目标位置超出距离向测绘带！'
    return;
end
el(1,7) = atand(z/(x(1,7)^2+y(1,7)^2)^0.5);     %目标实际俯仰角
atand(x(1,7)/y(1,7))

vr(1,7) = 104.9;             %目标径向速度
sita_ground(1,7) = 30;       %设定目标相对地面以北偏东sita_ground°运动
v_ground(1,7) = vr(1,7)/cosd(180-atand(x(1,7)/y(1,7))-sita_ground(1,7))/cosd(el(1,7)); %目标相对于地面的运动速度大小，方向为相对地面以北偏东sita_ground°
v_x(1,7) = v_ground(1,7)*sind(sita_ground(1,7));        %目标距离向分速度
v_y(1,7) = v_ground(1,7)*cosd(sita_ground(1,7));        %目标方位向分速度

return