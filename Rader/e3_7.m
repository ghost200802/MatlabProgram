f1=400;
f2=1000;
f3=2000;
T1=1/f1;
T2=1/f2;
T3=1/f3;
f=[f1 f2 f3];
fmax=max(f);
fmin=min(f);
sample=35*fmax;  %����Ƶ�ʵ����ھ�����С�Ĳ�����Ϊsample/fmax
Tmax=1/fmin;%��СƵ�ʶ�Ӧ������
N=6;     %��С��Ƶ�ʾ��е�������
t1=0:T1/sample*f1:N*Tmax;
t2=N*Tmax+T2/sample*f2:T2/sample*f2:2*N*Tmax;
t3=2*N*Tmax+T3/sample*f3:T3/sample*f3:3*N*Tmax;
T=[t1 t2 t3];
for i=1:length(T)
    t=T(i);
    if(t<=N*T1)
        st(i)=sin(2*pi*f1*t);
    else if(t<=2*N*T1)
            st(i)=sin(2*pi*f2*t);
        else
            st(i)=sin(2*pi*f3*t);
        end
    end
end
figure(1);
plot(0:1/sample:3*N*Tmax,st);
%���ź�st���ж�ʱ����Ҷ�任
figure(2);
spectrogram(st,255,200,255,sample,'yaxis');
axis([0 3*N*Tmax 0 2*fmax]);