function Plot_RASR
%Plot_RASR Summary of this function goes here
%��ȡ���ݣ��������յ�RASRͼ
%Detailed explanation goes here
close all;
clear all;
fid=fopen('beam report06.txt');
while ~feof(fid)
    [Input,Count]=fscanf(fid,'%f',3);
    
    th1=Input(1)*pi/180;
    th2=Input(2)*pi/180;
    [RASR,th]=Line_RASR(th1,th2,Input(3));
    plot(th*180/pi,RASR);
    
    hold on;    
end




