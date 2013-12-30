function [ OutputSignal ] = SincInterpolation( InputSignal,InterpolationPoints,SincPoints,SincFactor )
%SINCINTERPOLATION Summary of this function goes here
%   Detailed explanation goes here
beta = 2.5;         %匹配滤波所加的凯泽窗的系数


InputLength = size(InputSignal,2);          %输入的InputSignal和InterpolationPoints都是一维的数组
OutputLength = size(InterpolationPoints,2);
OutputSignal = zeros(1,OutputLength);

if(mod(SincPoints,2)==1)        %Sinc的点数必须为偶数
    SincPoints = SincPoints+1;
end



Factor = zeros(SincPoints,OutputLength);
for m = 1:SincPoints
    Factor(m,:) = (-1)*(InterpolationPoints-floor(InterpolationPoints)-m+SincPoints/2);
end
Factor = sinc(SincFactor*Factor);
Normalize = 1./sum(Factor.^2);
Factor = Factor.*(ones(1,SincPoints).'*Normalize);
Window =  kaiser(SincPoints,beta);       
Factor = Factor.*(Window*Normalize);

Position = floor(InterpolationPoints);
PositionLeft = Position-SincPoints/2+1;
PositionRight = Position+SincPoints/2;

for m = 1:OutputLength
    if(PositionLeft(m)<=0)
        PositionLeftZeros = 1-PositionLeft(m);
        PositionLeft(m) = 1;
    else
        PositionLeftZeros = 0;
    end
    if(PositionRight(m)>InputLength)
        PositionRightZeros = PositionRight(m)-InputLength;
        PositionRight(m) = InputLength;
    else
        PositionRightZeros = 0;
    end
    PartInput = [zeros(1,PositionLeftZeros),InputSignal(PositionLeft(m):PositionRight(m)),zeros(1,PositionRightZeros)];
        
    OutputSignal(m) = PartInput*Factor(:,m);

end

