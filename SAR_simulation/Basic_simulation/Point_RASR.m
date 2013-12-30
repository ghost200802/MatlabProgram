function RASR=Point_RASR(th,th_middle,Ha,PRF)
%Point_RASR Summary of this function goes here
%����ĳһ���RASR
%�����в��ù�һ������

%Detailed explanation goes here

[R,h,th_antenna,lamda,Ha0]=Parameters();

det_s=3e8/PRF/2;        %����ģ����֮����״ﲨ����������


s_max1=((R+h)^2-R^2)^0.5;                                                           %�״ﰲװ�Ƿ��������루��������������룩
s_max2=min(Distance(pi/2-th_antenna),s_max1);                                       %�״ﰲװ�Ƿ����������루���߰�װ���������������������о���Ľ�Сֵ��


R0=Distance(th);        %�źŷ���б��

P_sig=1*BC_coe(th)*G_antenna((th-th_middle),Ha)/(cos(th)*R0^4);

S1=R0+det_s:det_s:R0+fix((s_max1-R0)/det_s)*det_s;                                  %ģ�����ʷֳ������ּ��㣬�ֱ�ΪR0->s_max1,-s_max2->h,h->R0
S2=R0-fix((R0-h)/det_s)*det_s:det_s:R0+fix((s_max2-R0)/det_s)*det_s;
S3=R0-fix((R0-h)/det_s)*det_s:det_s:R0-det_s;

D1=Degree(S1);
D2=Degree(S2);
D3=Degree(S3);

P_blur1=sum(1*BC_coe(D1).*G_antenna((D1-th_middle),Ha).^2./(D1.*S1.^4));
P_blur2=sum(1*BC_coe(D2).*G_antenna((D2+th_middle),Ha).^2./(D2.*S2.^4));
P_blur3=sum(1*BC_coe(D3).*G_antenna((th_middle-D3),Ha).^2./(D3.*S3.^4));

P_blur=P_blur1+P_blur2+P_blur3;

RASR=10*log(P_sig/P_blur)/log(10);

end

