function [ OutputSignal ] = StretchDFT( InputSignal,K )
%DFT Summary of this function goes here
%   Detailed explanation goes here
[Col,Row] = size(InputSignal);

%InputSignal = FFTY(InputSignal);

M = fix(K*Col);
N = Col;

%AddCol =  2^ceil(log(Col)/log(2))-Col;

W = exp(-1i*2*pi/M);

G = [InputSignal.*(W.^((0:N-1).^2.'*ones(1,Row)/2));zeros(M,1)*ones(1,Row)];
G = FFTY(G);

H = W.^(-1*(-N+1:M).^2.'*ones(1,Row)/2);
H = FFTY(H);

V = G.*H;
V = IFFTY(V);

U = (W.^((1:M+N).^2.'*ones(1,Row)/2));
V = V.*U;


%OutputSignal = V(1:N,:);
%OutputSignal = V(round(M/2)+1:round(M/2)+N,:);
OutputSignal = V(N+M:-1:N+1,:)/N;           %别问我为什么。。。我也不知道！。。。
%OutputSignal = [OutputSignal(100:-1:75,:);OutputSignal(1:50,:)];
OutputSignal = IFFTY(OutputSignal);

end

