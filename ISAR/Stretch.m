function [ OutputSignal ] = Stretch( InputSignal,K )
%STRETCH Summary of this function goes here
%   Detailed explanation goes here
[InputCol,row] = size(InputSignal)

%OutputSignal = complex(spline(1:InputCol,real(InputSignal.'),1:K:InputCol).',spline(1:InputCol,imag(InputSignal.'),1:K:InputCol).');
%OutputSignal = StretchDFT(InputSignal,K);


InputMid = floor(InputCol/2);
OutputMid = round(InputMid*K);
OutputEnd = ceil(InputCol*K); 
if(K>1)         %保持输入输出数据格式的统一，根据K判断是对数据补0还是截取
    LeftZeros = InputMid-OutputMid;
    RightZeros = InputCol-OutputEnd-LeftZeros;
    OutputSignal = [zeros(LeftZeros,row);InputSignal;zeros(RightZeros,row)];
else
    LeftCut = OutputMid-InputMid+1;
    RightCut = OutputMid-InputMid+InputCol;
    OutputSignal = InputSignal(LeftCut:RightCut,:);
end

end

