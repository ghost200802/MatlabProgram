function [ Output ] = ZeroShift( Input,p )
%ZEROSHIFT Summary of this function goes here
%   Detailed explanation goes here
numDimsInput = ndims(Input);

if (numel(p) < numDimsInput)
    p(numDimsInput) = 0;
end

Output = circshift(Input,p);

if(numDimsInput <= 2)
    [ColInput,RowInput] = size(Input);
    Zeros = zeros(abs(p(1)),RowInput);    
    if(p(1)>0)
        Output = [Zeros;Output(p(1)+1:ColInput,:)];
    else
        Output = [Output(1:ColInput+p(1),:);Zeros];
    end
    
    Zeros = zeros(ColInput,abs(p(2)));  
    if(p(2)>0)
        Output = [Zeros,Output(:,p(2)+1:RowInput)];
    else
        Output = [Output(:,1:RowInput+p(2)),Zeros];
    end
end

        
    

end

