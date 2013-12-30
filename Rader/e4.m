close all
N=10000;
i=1:N;
f=1e4;
t=i/(f);
a=rand(1,N);
b=rand(1,N);

s=(a+j*b).*exp(j*2*pi*f*t);

subplot(2,1,1)
plot(i,abs(s))

fs=fty(s);

sp=fs.*conj(fs);

s_out=ifty(sp);
s_out=s_out-mean(s_out);

s_max=max(abs(s_out));
s_out=20*log10(abs(s_out)/s_max);

subplot(2,1,2)
plot(i,s_out)