function [S,Sdb] = USample2D(raw_data,N,M)
%*************************************************
%   rawΪԭʼ���źţ������ֵ���м䣬N*NΪ����������M Ϊ������ϵ��
%   ��raw_data�źŽ�ȡ�м��N�������M����������
%   ���ص�US_signal���ֵΪ0db
%**************************************************
SU = (raw_data);                                %ԭʼ�ź�  

%%�ҵ����ֵ�ĵ�λ��
[max_row,max_col] = find(abs(SU) == max(max(abs(SU))));
SU_loc =SU(ceil(max_row-N/2):1:ceil(max_row+N/2-1),ceil(max_col-N/2):1:ceil(max_col+N/2-1));   %�����ֵΪ�����ҵ�N*N����

%***ע�⣺��Ƶ�����ʱ����Ҫ�ԳƼӣ����ֱ�ӽ���ifft(SF,N*M)ֻ�����źŵ�β������****************
SF = fftshift(fft2(SU_loc,N,N));                         %����FFT
SFU = zeros(N*M,N*M);   
SFU(N*M/2-N/2:N*M/2+N/2-1,N*M/2-N/2:N*M/2+N/2-1) = SF;
S = ifft2(fftshift(SFU),N*M,N*M);
Sdb = 20*log10(abs(S)/(max(max(abs(S)))));              %�ź�ǿ�ȹ�һ��

%%��÷�λ��������ѹ���źŵ�λ��
[row,col] = find(Sdb == max(max(Sdb)));
[dim1,dim2] = size(Sdb);
max_loc = zeros(1,dim2);
Azmuth = zeros(1,dim2);
for la = 1:dim2
    temp = find(Sdb(:,la)== max(Sdb(:,la)));
    max_loc(la) = mean(temp);    %ÿ�����ֵ��ƽ����λ��   
    Azmuth(la) = Sdb(max_loc(la),la);
end;

%%%��ʾ%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Name','ѹ����Ŀ�����������Ķ�ά����');
subplot(121);
plot(Azmuth);
title('��������ķ�λ��ѹ���ź�');
subplot(122);
plot(Sdb(:,col));
title('��������ľ�����ѹ���ź�');
