function Test_27_CPF
%TEST_27_CPF Summary of this function goes here
%   Detailed explanation goes here
close all

K = 200;
T = 500;

k = (1:K)/T;

a0 = 10;
a1 = 20*pi;
a2 = 20*pi;
a3 = 0;

b0 = 10;
b1 = 0*pi;
b2 = -2*pi;
b3 = 0;

a = exp(-1i*(a0*(ones(1,K))+a1*k+a2*k.^2+a3*K.^3));
b = exp(-1i*(b0*(ones(1,K))+b1*k+b2*k.^2+b3*K.^3));



%a =(-K/2:K/2-1)/(K/T);
% a = (1:K)/(K/T);
% a = exp(-1i*a.^2);
% b = ((-K/2:K/2-1)+K/4)/(K/T);
% b = exp(-1i*b.^2);
%a = a+b;
figure,plot(real(a))
figure,plot(real(b))

Input = a;

Input = [zeros(1,K),Input,zeros(1,K)];

t = ones(K,1)*(K+1:K*2);
%tao = ((-K/2)+1:(K/2)).'*ones(1,K);
tao = (1:K).'*ones(1,K);

CPF = zeros(K,K);

for omega = 1:K
    CPF(omega,:) = sum((Input(t+tao).*Input(t-tao).*exp(-1i*2*pi*omega/K*(tao/T).^2)));
end

ICPF = sum(abs(CPF).^2);

myshow(CPF);

figure,plot(ICPF);

end

