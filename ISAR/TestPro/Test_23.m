function Test_23
%TEST_23 Summary of this function goes here
%   Detailed explanation goes here
close all
%a = sin((0:100)*pi/100).';
%a = (1:100).';
a = ([50:-1:1,1:50]).'*([2:-0.1:1,1:0.1:2]);
%figure,plot(a)
myshow(a);
for i = 0.5:0.05:1.5
    b = abs(StretchDFT(a,i));
    %figure,plot(b)
    myshow(b)
end

end

