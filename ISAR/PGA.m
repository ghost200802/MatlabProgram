function [ output_signal ] = PGA( input_signal )
%PGA Summary of this function goes here
%   Detailed explanation goes here
%使用PGA法进行初相校正
%%
%初始化
complex_signal = input_signal;
%output_signal = input_signal;
input_signal = abs(input_signal)/max(max(abs(input_signal)));
[R_scale A_scale] = size(input_signal);
thresh = 1e-2;
%%
%计算各距离单元数据方差
S = zeros(1,R_scale);
for i = 1:R_scale
    signal = input_signal(i,:);         %这里先去除了所有的0点，然后进行的方差计算
    signal = signal(signal~=0);
    if isempty(signal) || length(signal(signal>thresh))<A_scale
        S(i) = 1;
    else
        l = length(signal);
        S(i) = 1-((sum(signal)/l).^2./(sum(signal.^2)/l));
    end
end
%%
%显示各距离单元数据方差
%figure,plot(S)
%title('各距离单元数据方差');

%%
%窗长
windowLength = [24,10,6,4];
%PGA

signal_correct = complex_signal;
addAll_correctPhase = ones(1,A_scale);

for PGALoop = 1:1
    %多普勒跟踪
    for i = 2:A_scale
        e = conj(signal_correct(:,i-1)).*signal_correct(:,i);
        correctPhase = sum(e)/abs(sum(e));
        addAll_correctPhase(i) = addAll_correctPhase(i).*correctPhase;
        signal_correct(:,i) = signal_correct(:,i)/correctPhase;
    end

    %简单成像
    image = FFTX(signal_correct);
    %myshow(image);
    %寻找特显点，移位并加窗
    image_windowed = zeros(R_scale,A_scale);
    t_move = zeros(1,R_scale);
    for i = 1:R_scale
        [~,col] = find(abs(image(i,:)) == max(abs(image(i,:))));
        t_move(i) = (col(1)-round(A_scale/2));
        image(i,:) = circshift(image(i,:),[0,-t_move(i)]);
        %加矩形窗
        image_windowed(i,(round(A_scale/2)-windowLength(1)/2+1):(round(A_scale/2)+windowLength(PGALoop)/2)) = image(i,(round(A_scale/2)-windowLength(1)/2+1):(round(A_scale/2)+windowLength(PGALoop)/2)); 
    end
    %myshow(image_windowed);
    signal_correct = IFFTX(image_windowed);
end

%最终补偿
for i = 2:A_scale
    complex_signal(:,i) = complex_signal(:,i)/addAll_correctPhase(i);
end

output_signal = complex_signal;

%myshow(FFTX(complex_signal))
%%
%{
%%
%利用特显点对图像进行初相校正
%寻找特显点
i_sp = find(S==min(S));
i_sp = i_sp(1);
for i = 2:A_scale
    if(output_signal(i_sp,i)~=0)
        output_signal(:,i) = output_signal(:,i)*exp((-1)*1i*(angle(output_signal(i_sp,i))-angle(output_signal(i_sp,i-1))));
    end
end
%}
end

