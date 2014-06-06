function [ OutputSignal ] = DFT( InputSignal,K )
%DFT Summary of this function goes here
%   Detailed explanation goes here

[Col,Row] = size(InputSignal);
OutputSignal = zeros(Col,Row);
%{
%W = exp(-1i*2*pi/Col*((0:Col-1).*(1+K/Col*([round(Col/2)-1:-1:0,1:Col-round(Col/2)]))).'*(0:Col-1));
W = exp(-1i*2*pi/Col*(((0:Col-1).*(1+K/Col*([1:Col]))).'*(0:Col-1)));
for m = 1:Row
    OutputTemp(1:round(Col/2),m) = sum((InputSignal(:,m)*ones(1,round(Col/2))).*W(:,1:round(Col/2)));
end
myshow(OutputTemp)
OutputSignal(1:round(Col/2),:) = OutputTemp(1:round(Col/2),:);

W = exp(-1i*2*pi/Col*(((Col:-1:1).*(1+K/Col*([Col:-1:1])).^-1).'*(0:Col-1)));
for m = 1:Row
    OutputTemp(1:Col-round(Col/2),m) = sum((InputSignal(:,m)*ones(1,Col-round(Col/2))).*W(:,2:Col-round(Col/2)+1));
end
myshow(OutputTemp)
OutputSignal(round(Col/2)+1:Col,:) = OutputTemp(Col-round(Col/2):-1:1,:);
OutputSignal = fftshift(OutputSignal,1);
%}

tic
W = exp(-1i*2*pi/Col*(((0:Col-1).*(1+K/Col*(1:Col))).'*(0:Col-1)));
for m = 1:Row
    OutputSignal(1:round(Col/2),m) = sum((InputSignal(:,m)*ones(1,round(Col/2))).*W(:,1:round(Col/2)));
end

W = exp(-1i*2*pi/Col*(((Col-1:-1:0).*(1+K/Col*(Col-1:-1:0)).^-1).'*(Col-round(Col/2):-1:1)));
for m = 1:Row
    OutputSignal(round(Col/2)+1:Col,m) = sum((InputSignal(:,m)*ones(1,Col-round(Col/2))).*W(:,1:Col-round(Col/2)));
end
OutputSignal = fftshift(OutputSignal,1);
toc
end

