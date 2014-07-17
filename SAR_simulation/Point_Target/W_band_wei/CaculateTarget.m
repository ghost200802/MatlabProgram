function targetCondition = CaculateTarget(target,N_target,H0,L0,D,d,Bw,t,dx)
%CACULATETARGET Summary of this function goes here
%   Detailed explanation goes here
%对目标进行计算，得到的数组第一列还是后向散射系数，第二列是雷达坐标系中
%与雷达的距离，第三项是由于转动造成的与雷达连线方向的速度
targetPosition = zeros(N_target,2); %计算目标点在时间t时的位置


targetPosition(:,1) = sqrt((L0+target(:,2)+t*target(:,4)).^2 + H0^2);
targetPosition(:,2) = target(:,3)+t*target(:,5)-d;

targetCondition = zeros(N_target,3);

targetCondition(:,2) = sqrt((targetPosition(:,1)).^2+(targetPosition(:,2).^2))+sqrt((targetPosition(:,1)).^2+((targetPosition(:,2)+dx).^2)); %目标点与雷达的双程距离
targetCondition(:,3) = (D>= abs(target(:,3)-d)); %目标是否在成像范围内

th = targetPosition(:,2)./targetCondition(:,2);
Pa = sinc(pi/2*th/(Bw/2));
targetCondition(:,1) = target(:,1).*Pa.^2;  %目标点的等效后向散射系数
end

