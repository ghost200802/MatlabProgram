function [x,h]=SA(y,x0,h0)
[M1,M2]=size(h0);
[N1,N2]=size(x0);
x=100*ones(N1,N2);h=100*ones(M1,M2);
E=cost(y,x,h);Tk=100;
for i=1:100
    i
    Tk=Tk-1;
    for j=1:M1
        for k=1:M2
            dh=10*rand;
            h(j,k)=h(j,k)+dh;
            dE=cost(y,x,h)-E;
            if dE>=0 && exp(-dE/Tk)<=rand
                h(j,k)=h(j,k)-dh;
            end
        end
    end
        for j=1:N1
            for k=1:N2
                dx=10*rand;
                x(j,k)=x(j,k)+dx;
                dE=cost(y,x,h)-E;
                if dE<0 && exp(-dE/Tk)<=rand
                    x(j,k)=x(j,k)-dx;
            end
        end
    end
end
