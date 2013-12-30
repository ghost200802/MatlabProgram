function [ OutputSignal ] = Stretch( InputSignal,K )
%STRETCH Summary of this function goes here
%   Detailed explanation goes here
[InputCol,row] = size(InputSignal);

OutputSignal = complex(spline(1:InputCol,real(InputSignal.'),1:1/K:InputCol).',spline(1:InputCol,imag(InputSignal.'),1:1/K:InputCol).');


InputMid = floor(InputCol/2);
OutputMid = round(InputMid*K);
OutputEnd = size(OutputSignal,1); 
if(K<1)         %��������������ݸ�ʽ��ͳһ������K�ж��Ƕ����ݲ�0���ǽ�ȡ
    LeftZeros = InputMid-OutputMid;
    RightZeros = InputCol-OutputEnd-LeftZeros;
    OutputSignal = [zeros(LeftZeros,row);OutputSignal;zeros(RightZeros,row)];
else
    LeftCut = OutputMid-InputMid+1;
    RightCut = OutputMid-InputMid+InputCol;
    OutputSignal = OutputSignal(LeftCut:RightCut,:);
end

end

