function [ output_signal ] = MTRC( input_signal )
%MTRC Summary of this function goes here
%   Detailed explanation goes here
%%
%���λ����ΪRange*A_scale/K_interpolation,����Ҫ�����λ����С��R_scale/10(����ֻ���Ƽ�����ʵֻҪС��R_scale/2������ȷ��)
%�ɴ˵õ�Range/K_interpolation<R_scale/(10*A_scale);
%�ڱ���ģ���У���Լ��R_scale = 10*A_scale,������Range<K_interpolation
%%
%��ʼ��MTRC��ʹ�õ�����
Range = 3;         %������Χ
K_interpolation = 10;        %��ֵ����
virtual_interpolation = 5;  %�����ֵ������ͨ����Range/virtual_interpolation��Ϊƽ�Ƶĵ��������ﵽģ���������ô�౶��ֵ��Ч��
[R_scale A_scale] = size(input_signal);     %�õ����ݾ����С
input_signal = ValidData(input_signal,ceil(Range/virtual_interpolation*A_scale));
[R_scale A_scale] = size(input_signal);     %������Ч��������ݾ����С
[ F0,F_sample,B,PRF,T_pulse,T_measure,c ] = ParametersSystem();
T_sample = 1/F_sample;
theta = 2*pi*F0*T_sample/K_interpolation;
%%
%��ֵ����
fft_input_signal = fft(input_signal);
input_signal = zeros(R_scale*K_interpolation,A_scale);
input_signal(1:R_scale,:) = fft_input_signal;
input_signal = ifft(input_signal);
%%
%���ɴ�����ͼ��
output_signal = zeros(R_scale,A_scale);
%�ؼ�������3����������������
P1 = 41/Range;         %��Ҫͨ�������������3����������ô�õ���
P2 = 531;              %������range�޹ء���Ҳ�п����ǼǴ���
P3 = 16.2/Range;

h3 = waitbar(0,'MTRC');
for i = -Range:Range
    vertual_i = i/virtual_interpolation;
    shift_signal = LinearShift(input_signal,vertual_i,theta);
    shift_signal = shift_signal(1:K_interpolation:end,:);
    %figure,imshow(abs(shift_signal.')/max(max(abs(shift_signal))));
    fft_signal = fftshift(fft(shift_signal.'),1).';
    fft_signal = circshift(fft_signal,[0,round(P1*i)]);      %�����13.67Ӧ���ǿ���ͨ���ƶ��������ٶȼ���õ������Ƶ�
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

