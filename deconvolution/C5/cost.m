function y=cost(y,x,h)
y=sum(sum(x.^2))+sum(sum(h.^2))+sum(sum((y-conv2(x,h)).^2));

