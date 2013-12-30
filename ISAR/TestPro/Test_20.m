function Test_20
%TEST_20 Summary of this function goes here
%   Detailed explanation goes here
a = rand(100,100)+1i*rand(100,100);
figure,imagesc(abs(a)/max(max(abs(a)))),colormap(gray);
b = Stretch(a,2);
figure,imagesc(abs(b)/max(max(abs(b)))),colormap(gray);

end

