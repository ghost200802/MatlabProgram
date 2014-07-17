function [S,Sdb] = USample2D(raw_data,N,M)
%*************************************************
%   raw为原始复信号，其最大值在中间，N*N为采样点数，M 为过采样系数
%   对raw_data信号截取中间的N个点进行M倍的升采样
%   返回的US_signal最大值为0db
%**************************************************
SU = (raw_data);                                %原始信号  

%%找到最大值的点位置
[max_row,max_col] = find(abs(SU) == max(max(abs(SU))));
SU_loc =SU(ceil(max_row-N/2):1:ceil(max_row+N/2-1),ceil(max_col-N/2):1:ceil(max_col+N/2-1));   %以最大值为中心找到N*N个数

%***注意：在频域补零的时候需要对称加，如果直接进行ifft(SF,N*M)只是在信号的尾部加零****************
SF = fftshift(fft2(SU_loc,N,N));                         %数据FFT
SFU = zeros(N*M,N*M);   
SFU(N*M/2-N/2:N*M/2+N/2-1,N*M/2-N/2:N*M/2+N/2-1) = SF;
S = ifft2(fftshift(SFU),N*M,N*M);
Sdb = 20*log10(abs(S)/(max(max(abs(S)))));              %信号强度归一化

%%求得方位向采样后的压缩信号的位置
[row,col] = find(Sdb == max(max(Sdb)));
[dim1,dim2] = size(Sdb);
max_loc = zeros(1,dim2);
Azmuth = zeros(1,dim2);
for la = 1:dim2
    temp = find(Sdb(:,la)== max(Sdb(:,la)));
    max_loc(la) = mean(temp);    %每行最大值的平均列位置   
    Azmuth(la) = Sdb(max_loc(la),la);
end;

%%%显示%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Name','压缩点目标的升采样后的二维切面');
subplot(121);
plot(Azmuth);
title('升采样后的方位向压缩信号');
subplot(122);
plot(Sdb(:,col));
title('升采样后的距离向压缩信号');
