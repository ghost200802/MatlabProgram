function targetCondition = CaculateTarget(target,N_target,H0,L0,D,d,Bw)
%CACULATETARGET Summary of this function goes here
%   Detailed explanation goes here
%对目标进行计算，得到的数组第一列还是后向散射系数，第二列是雷达坐标系中
%与雷达的距离，第三项是由于转动造成的与雷达连线方向的速度
targetPosition = zeros(N_target,2); %计算目标点在时间t时的位置


targetPosition(:,1) = sqrt((L0+target(:,2)).^2 + H0^2);
targetPosition(:,2) = target(:,3)-d;

    
%targetPosition(:,1) = target(:,2)*cos(Omega*t)+target(:,3)*sin(Omega*t); %x'=x*cos(wt)+y*sin(wt)
%targetPosition(:,2) = target(:,3)*cos(Omega*t)-target(:,2)*sin(Omega*t); %y'=y*cos(wt)-x*sin(wt)

targetCondition = zeros(N_target,3);

targetCondition(:,2) = sqrt((targetPosition(:,1)).^2+(targetPosition(:,2).^2)); %目标点与雷达的距离
targetCondition(:,3) = (D>= abs(target(:,3)-d)); %目标是否在成像范围内

th = targetPosition(:,2)./targetCondition(:,2);
Pa = sinc(0.886*th/Bw);
targetCondition(:,1) = target(:,1).*Pa.^2;  %目标点的等效后向散射系数
end

