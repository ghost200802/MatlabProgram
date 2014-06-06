function ReturnSimulate
%RETURNSIMULATE Summary of this function goes here
%   Detailed explanation goes here
%本函数用来进行回波的模拟

%还没有加入天线方向图！！！！------------------------------------------
%%
%获得原始数据及相关数据计算
[ ~,F0,F_sample,B,PRF,T_pulse,c,H0,L0,L_min,L_max,Bw,D,d_min,d_max,Vr ] = ParametersSystem();
[target,N_target] = Target();

T_sample = 1/F_sample;                      %系统采样时间，单位为秒
R_min = sqrt(H0^2 + L_min^2);               %最早接受数据对应的目标距离，也即最小的接收数据的距离
R_max = sqrt(H0^2 + L_max^2 + D^2);     %最晚接收数据对应的目标距离，也即最大的接收数据的距离
T_min = 2*R_min/c;                          %最早的接收数据时间
T_max = 2*R_max/c;                          %最晚的接收数据时间
K = B/T_pulse;                              %信号的调频率
T_measure = (d_max - d_min)/Vr;             %总测量时间
n_pulse = round(T_measure*PRF);             %总共的发射脉冲数量
i_pulselength = round(T_pulse/T_sample);    %发射脉冲序列长度
i_pulse = 1:i_pulselength;                  %发射脉冲的脉冲序列
i_pulse = i_pulse*T_sample;                 %发射脉冲的时间采样信号
i_receive = round((T_max-T_min)/T_sample)+i_pulselength; %每次脉冲的接收窗采样序列长度

%%
%初始化
signal_return_real = zeros(n_pulse,i_receive);
signal_return_imag = zeros(n_pulse,i_receive);

%%
%生成参考信号
signal_reference = exp(1i*(2*pi*F0*i_pulse+pi*K*i_pulse.^2));
%%
%生成回波数据
h1 = waitbar(0,'生成数据');
for i = 1:n_pulse
    targetCondition = CaculateTarget(target,N_target,H0,L0,D,d_min+i/PRF*Vr,Bw);
    for k = 1:N_target
        if(targetCondition(k,3))
            t_return = 2*targetCondition(k,2)/c - T_min;                                      %这里是从T_min开始也就是从接收回波开始计时后的时间，为了与回波接收的数据结相吻合
            i_return = round(t_return/T_sample);                                              %这里计算的是在第几个采样脉冲时开始接收到回波信号
            signal_return_target = targetCondition(k,1)*exp(1i*(2*pi*F0*(i_pulse-(t_return-i_return*T_sample))+pi*K*(i_pulse-(t_return-i_return*T_sample)).^2));                  %这是每个目标的回波
            signal_return_real(i,i_return : i_return+i_pulselength-1) = signal_return_real(i,i_return : i_return+i_pulselength-1)+real(signal_return_target); %把每个目标的回波叠加进脉冲的接收回波
            signal_return_imag(i,i_return : i_return+i_pulselength-1) = signal_return_imag(i,i_return : i_return+i_pulselength-1)+imag(signal_return_target);
        end
    end
    waitbar(i/n_pulse);
end
close(h1);
signal_return = complex(signal_return_real,signal_return_imag);
%%
%显示结果
%{
figure
plot(real(signal_return(1,:)));
title('第1次脉冲的回波信号');
figure
plot(real(signal_reference));
title('参考信号');
%}
%%
%将结果进行格式匹配
signal_return  = signal_return.';
signal_reference = signal_reference.';

figure
imagesc(real(signal_return)),colormap(gray)

save('ReturnSimulate.mat','signal_return','signal_reference');
end

