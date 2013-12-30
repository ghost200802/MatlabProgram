f0=5.321e9;
w0=2*pi*f0;
B=40e6;
Tp=6e-6; 
alpha=2*pi*B/Tp;
c=3e8;
fs=2*B*50;
R0=1e3;
X0=40;
Ts=(2*(R0-X0))/c; 
Te=(2*(R0+X0))/c+Tp; 
n=2*ceil(0.5*(Te-Ts)*fs);
t=Ts+(0:n-1)/fs;
d=R0+0.5*c/fs*(-n/2:n/2-1);
ntarget=4; 
xn(1)=995;    fn(1)=1;
xn(2)=1000;     fn(2)=1.5;
xn(3)=1001;     fn(3)=2.25;
xn(4)=1005;     fn(4)=3.375;
sr=zeros(1,n);
for i=1:ntarget
td=t-2*(xn(i))/c;
s=fn(i).*exp(j*(w0-0.5*alpha*Tp)*td+j*(0.5*alpha*td.^2)).*(td>=0&td<=Tp);
    sr=sr+s;
end
sb=sr.*exp(-j*w0*t);
td0=t-2*R0/c;
s0=exp(j*(w0*(2*R0/c)-0.5*alpha*Tp*td0)+j*0.5*alpha*td0.^2).*(td0>=0&td0<=Tp);
fsb=fty(sb);
fs0=fty(s0);
fsout=fsb.*conj(fs0); sout=ifty(fsout);
sout_max=max(abs(sout));
sout=20*log10(abs(sout)/sout_max);
figure(1);
plot(d,sout);
xlabel('¾àÀë m')
ylabel('»Ø²¨¹¦ÂÊ dB')
axis([R0-X0 R0+X0 -45 0]);