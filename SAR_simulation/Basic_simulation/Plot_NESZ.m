function Plot_NESZ
%PLOT_NESZ Summary of this function goes here
%»­³öNESZ
%Detailed explanation goes here

close all;
clear all;
fid=fopen('beam report06.txt');

i=1;
while ~feof(fid)
    [Input,Count]=fscanf(fid,'%f',3);  
    th_middle(i)=(Input(1)+Input(2))*pi/360;
    PRF=Input(3); 
       
    if(th_middle(i)<33*pi/180)
        Br=6e8;
    end
    
    if((th_middle(i)>=33*pi/180) & (th_middle(i)<43*pi/180))
        Br=5e8;
    end
    if(th_middle(i)>=43*pi/180)
        Br=4e8;
    end
    
    th1=Input(1)*pi/180;
    th2=Input(2)*pi/180; 
  
    Ha=Equ_Ha(th1,th2);

    NESZ(i)=Caculate_NESZ(th_middle(i),PRF,Br,Ha);
    i=i+1;
        
    hold on
    
end

plot(th_middle*180/pi,NESZ)



