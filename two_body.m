function xdot = two_body(t,x0)
        
mue = 398600;
r_mag = norm(x0(1:3)); 

xdot = zeros(size(x0));
xdot(1:3,1) = x0(4:6);


xdot(4,1) = -(mue/(r_mag^3)).*x0(1);
xdot(5,1) = -(mue/(r_mag^3)).*x0(2);
xdot(6,1) = -(mue/(r_mag^3)).*x0(3);
