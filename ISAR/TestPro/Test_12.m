function Test_12
%TEST_12 Summary of this function goes here
%   Detailed explanation goes here
T_sample = 0.1;
T = 500;
T_ref = 800;
fc = 1000;
K = 10;

T = -T:T;
T_ref = -T_ref:T_ref;
T = T*T_sample;
T_ref = T_ref*T_sample;


end

