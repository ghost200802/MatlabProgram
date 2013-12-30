c=3e8;
f0=5.321e9;
df=20e6; N=21;
R0=1e3;  ntarget=4; 
xn(1)=-5;    fn(1)=1;
xn(2)=0;     fn(2)=1.5;
xn(3)=1;     fn(3)=2.25;
xn(4)=5;     fn(4)=3.375;
fprb=zeros(1,N);
for m=1:ntarget
    fp=exp(-j*2*pi*f0);
    ii=0;
    for i=1:N
        ii=ii+1;
        Td=2*(R0+xn(m))/c;
        phase=-2*pi*(f0+(i-1)*df)*Td;
        fprb(ii)=fprb(ii)+fn(m)*exp(j*phase);
    end
end
fpout(1:N)=fprb;
fpout(N:2*N)=0+j*0;
pout=ifty(fpout);
pout_max=max(abs(pout));
dB_pout=20*log10(abs(pout)./pout_max);
plot(dB_pout);
xlabel('相对位置')
ylabel('回波功率')
axis([0 160 -50 0]);