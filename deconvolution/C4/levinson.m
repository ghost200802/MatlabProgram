function a = levinson(R,N)
%LEVINSON Summary of this function goes here
%   Detailed explanation goes here
a(1) = R(2)/R(1);
E(1) = R(1);
for n = 2:N-1
    a(n) = (R(N+1)+sum(R(2:n).*a(n-1:-1:1)))/E(n-1);
    a(1:n-1) = a(1:n-1)+a(n-1:-1:1)*a(n);
    E(n) = E(n-1)*(1-a(n)^2);
end
x(1:N-1) = a;
x(N) = E(N-1);

end

