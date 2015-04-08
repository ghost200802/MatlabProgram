function [ output_signal ] = PhaseCorrection_Doppler( input_signal )
%PHASECORRECTION Summary of this function goes here
%   Detailed explanation goes here
%ʹ�ö����ո��ٷ����г���У��
%%
%��ʼ��
output_signal = input_signal;
input_signal = abs(input_signal)/max(max(abs(input_signal)));
[R_scale A_scale] = size(input_signal);
thresh = 1e-2;
%%
%��������뵥Ԫ���ݷ���
S = zeros(1,R_scale);
for i = 1:R_scale
    signal = input_signal(i,:);         %������ȥ�������е�0�㣬Ȼ����еķ������
    signal = signal(signal~=0);
    if isempty(signal) || length(signal(signal>thresh))<A_scale
        S(i) = 1;
    else
        l = length(signal);
        S(i) = 1-((sum(signal)/l).^2./(sum(signal.^2)/l));
    end
end
%%
%��ʾ�����뵥Ԫ���ݷ���
%figure,plot(S)
%title('�����뵥Ԫ���ݷ���');

for i = 2:A_scale
    e = conj(output_signal(:,i-1)).*output_signal(:,i);
    correctPhase = sum(e)/abs(sum(e));
    output_signal(:,i) = output_signal(:,i)/correctPhase;
end
%%
%{
%%
%�������Ե��ͼ����г���У��
%Ѱ�����Ե�
i_sp = find(S==min(S));
i_sp = i_sp(1);
for i = 2:A_scale
    if(output_signal(i_sp,i)~=0)
        output_signal(:,i) = output_signal(:,i)*exp((-1)*1i*(angle(output_signal(i_sp,i))-angle(output_signal(i_sp,i-1))));
    end
end
%}
end

