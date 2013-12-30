function C5P5
%C5P5 Summary of this function goes here
%   Detailed explanation goes here
xs = [1 2 3; 4 5 6; 7 8 9];
hs = rand(2,2);
ys = conv2(xs,hs);
x0 = xs;
h0 = rand(2,2);
[x,h] = blind_decon(ys,x0,h0,1e-12)

end

