function targetCondition = CaculateTarget( target,N_target,L0,Omega,t )
%CACULATETARGET Summary of this function goes here
%   Detailed explanation goes here
%对目标进行计算，得到的数组第一列还是后向散射系数，第二列是雷达坐标系中
%与雷达的距离，第三项是由于转动造成的与雷达连线方向的速度
targetPosition = zeros(N_target,2); %计算目标点在时间t时的位置

targetPosition(:,1) = target(:,2)*cos(Omega*t)+target(:,3)*sin(Omega*t); %x'=x*cos(wt)+y*sin(wt)
targetPosition(:,2) = target(:,3)*cos(Omega*t)-target(:,2)*sin(Omega*t); %y'=y*cos(wt)-x*sin(wt)

targetCondition = zeros(N_target,2);

targetCondition(:,1) = target(:,1);  %目标点的后向散射系数
targetCondition(:,2) = ((L0+targetPosition(:,1)).^2+(targetPosition(:,2).^2)).^0.5; %目标点与雷达的距离


end

