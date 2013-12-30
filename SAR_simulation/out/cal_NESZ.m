%��������
H=675e3;           %���Ǹ߶�
Re = 6371e3;       %����뾶
Vs=7590;           %ƽ̨�˶��ٶ�
fc=9.6e9;
LF=10^0.3;         %���
Laz=10^0.17;
T=290;             %�����¶�ֵ 
K=1.38*10^(-23);   %������������
c=3e8;  
tr=1.2*10^(-4);    %������
Pt=2e4;            %�����źŹ���
Ha=2.923 ;          %���߿��
La=0.9;            %���߷�λ�򳤶�
A=Ha*La  ;         %�������
bc=c/fc  ;         %����
G=4*pi*A/(bc^2);   %��������
ante_eff=0.85 ;    %����Ч��

%����NESZ    
fid=fopen('beam report06.txt');
i = 1;
NESZ = zeros(1,length(fid));
xaxs = zeros(1,length(fid));
while ~feof(fid)                              %��ȡ���и����Ĳ����Ƕȡ�PRF
[dates,count]=fscanf(fid,'%f',3);             %��ȡ�����ĽǶȣ���PRF����
beam_c=dates(1);                              %���겨����Χ
beam_r=dates(2); 
beam_mid=(beam_c+beam_r)/2;                   %��������
PRF=dates(3);                                 %��ȡ����PRFֵ 
R0=(H+Re)*cos(beam_mid*pi/180)-sqrt(Re^2-((Re+H)^2)*((beam_mid*pi/180)^2));  %�״����õ��б��
if(beam_mid<33)
    Br=6e8;
end
if(beam_mid>=33&beam_mid<43)
    Br=5e8;
end
if(beam_mid>=43)
    Br=4e8;
end

NESZ1=256*(pi^3)*(R0^3)*sin(beam_mid*pi/180)*Vs*Br*K*T*LF*Laz/(Pt*(G^2)*bc^3*tr*PRF*c) %NESZ�ļ��㹫ʽ
NESZ(i)=10*log(NESZ1)/log(10);
%plot(beam_mid,NESZ);
%hold on;    
disp(NESZ(i));
xaxs(i) = beam_mid;
i = i+1;
end
plot(xaxs,NESZ);

