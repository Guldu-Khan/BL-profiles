function rhs = blassius_rhs(x,Y)

Pr=1;
rhs = [ Y(2); Y(3); -Y(1)*Y(3)*Pr/2];