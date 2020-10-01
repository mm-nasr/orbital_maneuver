function [r0,v0] = COE2RV(a,e,inc,OM,om,anom)  
muu = 3.986e5;

% Get r and v in PQW plane
p = a*(1-(e^2));

r_PQW = (1/(1+e*cosd(anom))).* [p*cosd(anom) p*sind(anom) 0];
v_PQW = sqrt(muu/p).*[-sind(anom) e+cosd(anom) 0];

%rotation matrix to transform from PQW to IJK frame
ROT = [(cosd(OM)*cosd(om))-(sind(OM)*sind(om)*cosd(inc)) , (-cosd(OM)*sind(om))-(sind(OM)*cosd(om)*cosd(inc)) , sind(OM)*sind(inc);
       (sind(OM)*cosd(om))+(cosd(OM)*sind(om)*cosd(inc)) , (-sind(OM)*sind(om))+(cosd(OM)*cosd(om)*cosd(inc)) , -cosd(OM)*sind(inc);
        sind(om)*sind(inc)                               , cosd(om)*sind(inc)                                 ,  cosd(inc)        ];

% Get r,v in IJK plane
r0 = ROT*r_PQW';
v0 = ROT*v_PQW';