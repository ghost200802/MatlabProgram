function [ terrain ] = inputTerrain
%INPUTTERRAIN Summary of this function goes here
%   Detailed explanation goes here
fid=fopen('terrain.txt');
parameter = fscanf(fid,'%f',2);

terrain = zeros(parameter(1),parameter(2));

i = 0;
while ~feof(fid)
    i = i+1;
    terrain(i,:) = fscanf(fid,'%f',parameter(2));  
end

fclose(fid);
end

