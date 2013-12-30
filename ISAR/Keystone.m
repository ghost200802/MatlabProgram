function [ output_signal] = Keystone( input_signal )
%KEYSTONE Summary of this function goes here
%   Detailed explanation goes here
%%
%��ʼ��
[ F0,F_sample,B,~,~,~,~ ] = ParametersSystem();
[R_scale,A_scale] = size(input_signal);

Fc = F0+B/2;                                        %��������Ƶ��
K_mid = floor((Fc-F_sample/2)/F_sample);            %��������Ƶ�ʵ��۵�����
K_mid = max(0,K_mid);
N_Fc = round(R_scale*Fc/F_sample-(K_mid+1/2)*R_scale);        %�ź�����Ƶ����Ƶ��ͼ�����ڵ� 
N_Fc = min(R_scale,max(0,N_Fc));                              
%%
%�ź�Ԥ����
input_signal = FFTY(input_signal);
input_signal = circshift(input_signal,[round(N_Fc-R_scale/2),0]);

%%
%Keystone�任����
keystone_signal = zeros(R_scale,A_scale);
N_Fc_new = round(R_scale/2);
Ratio = (Fc./(Fc+((1:R_scale)-N_Fc_new)*F_sample/R_scale));    %��ʽ��Ratio = fc/(fc+f),����fΪƵ��ͼ��ĳ���Ӧ��Ƶ�ʣ����㷽��Ϊ(x-x_mid)*F_sample/R_scale

for m = 1:R_scale
    %{
    for n = 1:A_scale
        n_old = Ratio(m)*(n-A_scale/2)+A_scale/2;
        %n_old = Ratio(m)*n;
        n_old = round(K_interpolation*n_old);
        n_old = min(n_old,(A_scale-1)*K_interpolation);
        n_old = max(n_old,1);
        keystone_signal(m,n) = input_signal(m,n_old);
    end
    %}
    n_old = Ratio(m)*((1:A_scale)-A_scale/2)+A_scale/2;
    n_old(n_old<1) = 1;
    n_old(n_old>A_scale) = A_scale;    
    keystone_signal(m,:) = complex(spline(1:A_scale,real(input_signal(m,:).'),n_old),spline(1:A_scale,imag(input_signal(m,:).'),n_old)).';
end

output_signal = circshift(keystone_signal,[0,-round(N_Fc-R_scale/2)]);
A_scale_min = round(A_scale*(1-min(Ratio))/2);
A_scale_max = A_scale-A_scale_min;
output_signal = output_signal(:,A_scale_min:A_scale_max);
%figure,imagesc(abs(input_signal.')/max(max(abs(input_signal)))),colormap(gray)
figure,imagesc(abs(output_signal.')/max(max(abs(keystone_signal)))),colormap(gray) 
title('KeystoneУ����Ķ�������ͼ')
output_signal = IFFTY(output_signal);
end

