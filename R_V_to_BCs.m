function [Rmag,Vmag,energy,a,e,inc,T] = R_V_to_BCs(R_vec,V_vec)
%Constants
% Mass_Earth=6.66*10^26;
% Grav_const=5.972*10^24;
% mue=Mass_Earth*Grav_const;
mue=3.986*10^5; %gravitational parameter - - - km^3/s^2


%vernier equinox axis
I = [1 0 0];
J = [0 1 0];
K = [0 0 1];

%obtaining specific angular momentum by cross multiplying RxV
h_vec=cross(R_vec,V_vec);

%obtaining magnitudes
Vmag=norm(V_vec);
Rmag=norm(R_vec);
h=sqrt(dot(h_vec,h_vec));

%calculating orbit specifications
energy=Vmag.^2/2 - mue/Rmag;          %specific energy %MJ/kg
a= -mue/(2*energy);             %semi-major axis
e_vec = (1/mue)*((((Vmag^2)-(mue/Rmag))*R_vec)-((dot(R_vec,V_vec))*V_vec));   % Eccentricity vector
e=sqrt(dot(e_vec,e_vec));
T = 2*pi*sqrt(a.^3/mue);
%Obtaining Angles
inc = acos(dot(K,h_vec)/h);  % Inclination angle
    