function rhs = rhs_faulkner(t,y)

global n;

rhs = zeros(3,1);    % a column vector

rhs(1) = y(2);
rhs(2) = y(3);
rhs(3) = (-(n+1)*0.5*y(1)*y(3)) + n*(y(2))^2 - n;