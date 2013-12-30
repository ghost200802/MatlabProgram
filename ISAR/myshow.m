function myshow( image )
%COMPLEXIMAGESC Summary of this function goes here
%   Detailed explanation goes here
figure,imagesc(abs(image)/max(max(abs(image)))),colormap(gray);

end
