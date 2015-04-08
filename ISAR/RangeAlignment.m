function [ output_signal ] = RangeAlignment( input_signal,signal_center)
%RANGEALIGNMENT Summary of this function goes here
%   Detailed explanation goes here
%ʹ����С�ط����ж���
%%
%���þ���������
Range = 5;     %���������ÿ��������Χ
K_interpolation = 3;        %��ֵ����
[R_scale A_scale] = size(input_signal);     %�õ����ݾ����С
Factor = 1;   %ָ����Ȩ�ı���
%%
%��ֵ����
%input_signal = Interpolation(input_signal,K_interpolation);
input_signal = complex(spline(1:R_scale,real(input_signal.'),1:1/K_interpolation:R_scale).',spline(1:R_scale,imag(input_signal.'),1:1/K_interpolation:R_scale).');
%%
%��ʼ���������
output_signal = input_signal;
%%
%��ʼ�����������ʹ�õ�����
%input_signal = ValidData(input_signal,Range);
%%
%������봦��
U_sum = input_signal(:,1);      %�Ѿ�������İ����
h2 = waitbar(0,'�������');
for i = 2:A_scale                                   %�����Ǵӵ�2�п�ʼ���ж���
    if i == 600
        i = 600;
    end
    if i == 676
        i = 676;
    end
    if i == 700
        i = 700;
    end
    t_move = MinEntropy(U_sum,input_signal(:,i),Range*K_interpolation,round((signal_center(i)-signal_center(1))*K_interpolation));        %���ú���
    output_signal(:,i) = circshift(output_signal(:,i),[t_move,0]);        %��ĳһ�н��ж���
    U_sum = (U_sum*Factor*(i-1)+output_signal(:,i))/i;               %�������м���U_sum
    %U_sum = output_signal(:,i);
    waitbar(i/A_scale);
end
delete(h2);
output_signal = output_signal(1:K_interpolation:end,:);
