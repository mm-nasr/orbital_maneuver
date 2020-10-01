function V_I = VUW2I(V,FPA,psi,xo)
%   This function transforms the vector from VUW frame to the Inertial
%   Frame
%   INPUT:
%           1- V    :       Velocity Magnitude in VUW frame
%           2- FPA  :       Flight Path Angle
%           3- psi  :       Out of plane angle (inclination)
%           4- xo   :       Initial State Vector [Rx Ry Rz Vx Vy Vz]
%--------------------------------------------------------------------------

Rot1 = [ cos(-FPA)      sin(FPA)        0   ;
        -sin(FPA)       cos(FPA)        0   ;
            0               0           1 ] ;
        
Rot2 = [ cos(psi)           0     -sin(psi) ;
            0               1           0   ;
         sin(psi)           0      cos(psi)];
     
ROT = Rot1*Rot2;

dv = ROT*[V;0;0];   % 3 x l

Ro(:,1) = xo(1:3);        Vo(:,1) = xo(4:6);
Ho  = cross(Ro,Vo); w = Ho/norm(Ho);    v = Vo/norm(Vo);    u = cross(w,v);
    
DV  =[v u w]* dv;
    
V_I  = Vo + DV;
