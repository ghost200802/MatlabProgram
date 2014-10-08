function [ RCS ] = inputRCS
%INPUTTERRAIN Summary of this function goes here
%   Detailed explanation goes here
fid=fopen('RCS.txt');
parameter = fscanf(fid,'%f',2);

RCS = zeros(parameter(1),parameter(2));

i = 0;
while ~feof(fid)
    i = i+1;
    RCS(i,:) = fscanf(fid,'%f',parameter(2));  
end

fclose(fid);
end

