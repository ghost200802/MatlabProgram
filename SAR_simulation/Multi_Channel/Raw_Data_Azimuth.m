function raw_data_azimuth = Raw_Data_Azimuth
%RAW_DATA Summary of this function goes here
%原始数据
%   Detailed explanation goes here

[ Vs,F0,H,Br,PRF,N,daz,c ] = Parameters();

M = 10000;                      %采样次数

det_S = Vs/PRF;                 %相邻采样点距离

if(det_S<daz)                   %Warning
    Warning = 'PRF过大'
end

for i = 1:N                     %计算各采样点时各子天线位置
    for j = 1:M
        X(i,j) = (i-(N+1)/2)*daz+(j-1)*det_S;
    end
end

N_Target=0;                     %读取目标位置
fid=fopen('Target_Azimuth.txt');        
while ~feof(fid)
    N_Target = N_Target+1;
    Target(N_Target) = fscanf(fid,'%f',1);
end

%raw_data_azimuth=

Target

end

