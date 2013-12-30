function [ output_signal ] = MTRC( input_signal )
%MTRC Summary of this function goes here
%   Detailed explanation goes here
%%
%最大位移量为Range*A_scale/K_interpolation,尽量要求最大位移量小于R_scale/10(这里只是推荐，其实只要小于R_scale/2就是正确的)
%由此得到Range/K_interpolation<R_scale/(10*A_scale);
%在本次模拟中，大约有R_scale = 10*A_scale,所以有Range<K_interpolation
%%
%初始化MTRC所使用的数据
Range = 3;         %搜索范围
K_interpolation = 10;        %插值倍数
virtual_interpolation = 5;  %虚拟插值倍数：通过将Range/virtual_interpolation作为平移的点数，来达到模拟进行了这么多倍插值的效果
[R_scale A_scale] = size(input_signal);     %得到数据矩阵大小
input_signal = ValidData(input_signal,ceil(Range/virtual_interpolation*A_scale));
[R_scale A_scale] = size(input_signal);     %修正有效化后的数据矩阵大小
[ F0,F_sample,B,PRF,T_pulse,T_measure,c ] = ParametersSystem();
T_sample = 1/F_sample;
theta = 2*pi*F0*T_sample/K_interpolation;
%%
%插值处理
fft_input_signal = fft(input_signal);
input_signal = zeros(R_scale*K_interpolation,A_scale);
input_signal(1:R_scale,:) = fft_input_signal;
input_signal = ifft(input_signal);
%%
%生成处理结果图像
output_signal = zeros(R_scale,A_scale);
%关键就是这3个参数啊！！！！
P1 = 41/Range;         %需要通过计算解释如下3个数字是怎么得到的
P2 = 531;              %可能与range无关——也有可能是记错了
P3 = 16.2/Range;

h3 = waitbar(0,'MTRC');
for i = -Range:Range
    vertual_i = i/virtual_interpolation;
    shift_signal = LinearShift(input_signal,vertual_i,theta);
    shift_signal = shift_signal(1:K_interpolation:end,:);
    %figure,imshow(abs(shift_signal.')/max(max(abs(shift_signal))));
    fft_signal = fftshift(fft(shift_signal.'),1).';
    fft_signal = circshift(fft_signal,[0,round(P1*i)]);      %这里的13.67应该是可以通过移动带来的速度计算得到，需推导
    figure,contour(abs(fft_signal.')/max(max(abs(fft_signal))));
    if(i == -Range)
        output_signal(:,round(P2-P3/2+(-1)*i*P3):A_scale) = fft_signal(:,round(P2-P3/2+(-1)*i*P3):A_scale);
    else if(i == Range)
            output_signal(:,1:round(P2+P3/2+(-1)*i*P3)) = fft_signal(:,1:round(P2+P3/2+(-1)*i*P3));
        else
            output_signal(:,round(P2-P3/2+(-1)*i*P3):round(P2+P3/2+(-1)*i*P3)) = fft_signal(:,round(P2-P3/2+(-1)*i*P3):round(P2+P3/2+(-1)*i*P3));
        end
    end
    %output_signal = output_signal+abs(fft_signal);
    waitbar(((i+Range)+1)/(2*Range+1));
end
delete(h3);
%output_signal = output_signal/(2*Range+1);



end

