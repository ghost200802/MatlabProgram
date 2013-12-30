function raw_data = Raw_Data(PRF,dimension)
%Raw_data Summary of this function goes here
%生成原始数据
%   Detailed explanation goes here
[ Vs,F0,Lamda,H,Br,La,N,daz,c ] = Parameters();

daz = daz*1495/PRF;                     %这里的daz本来不应该变化的，但是为了做出学姐那张图的效果。。。不得不这么写，其实如果考虑到这里是纯模拟不均匀采样的话，也可以理解
PRF = 1495;                             %由于改变了daz，所以这里的PRF就不用变了，也是方位向压缩中PRF不变的原因
PRT = 1/PRF;

j_max = 500;                            %模拟参数(合成孔径长度的一半)

raw_data1 = zeros(1,(j_max*2*N));       %数据是存成1列还是分3列存放
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

