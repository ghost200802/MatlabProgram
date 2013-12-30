function raw_data = Raw_Data(PRF,dimension)
%Raw_data Summary of this function goes here
%����ԭʼ����
%   Detailed explanation goes here
[ Vs,F0,Lamda,H,Br,La,N,daz,c ] = Parameters();

daz = daz*1495/PRF;                     %�����daz������Ӧ�ñ仯�ģ�����Ϊ������ѧ������ͼ��Ч�����������ò���ôд����ʵ������ǵ������Ǵ�ģ�ⲻ���Ȳ����Ļ���Ҳ�������
PRF = 1495;                             %���ڸı���daz�����������PRF�Ͳ��ñ��ˣ�Ҳ�Ƿ�λ��ѹ����PRF�����ԭ��
PRT = 1/PRF;

j_max = 500;                            %ģ�����(�ϳɿ׾����ȵ�һ��)

raw_data1 = zeros(1,(j_max*2*N));       %�����Ǵ��1�л��Ƿ�3�д��
raw_data2 = zeros(N,j_max*2);

for i = 1:N
    for k = 1:2*j_max
        raw_data1((k-1)*3+i) = exp(-j*4*pi*H/Lamda)*exp(-j*pi*(((N+1)/2-i)*daz)^2/2/Lamda/H)*exp(-j*2*pi*Vs^2/Lamda/H*((k-(j_max+1))*PRT-((N+1)/2-i)*daz/2/Vs)^2);
        raw_data2(i,k) = raw_data1((k-1)*3+i);
    end
end

if dimension == 1
    raw_data = raw_data1;
end

if dimension == 2
    raw_data = raw_data2;
end

end

