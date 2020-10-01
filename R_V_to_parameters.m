function [a,e,inc,OM,om,anom] = R_V_to_parameters(R_vec,V_vec)
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
v_0=norm(V_vec);
r_0=norm(R_vec);
h=sqrt(dot(h_vec,h_vec));

%calculating orbit specifications
energy=v_0.^2/2 - mue/r_0;          %specific energy %MJ/kg
a= -mue/(2*energy);             %semi-major axis
e_vec = (1/mue)*((((v_0^2)-(mue/r_0))*R_vec)-((dot(R_vec,V_vec))*V_vec));   % Eccentricity vector
e=sqrt(dot(e_vec,e_vec));

if e<0.0001
    disp('Orbit is Circular.\n')
    radius = r_0;
    
    %normal vector to orbit
    n_vec = cross(K,h_vec);             % Vector n (nodal vector) pointing towards the ascending node
    n = sqrt(dot(n_vec,n_vec));                 %determinant of n
    
    %Obtaining Angles
    inc = acosd(dot(K,h_vec)/h);  % Inclination angle
    if inc>=0 && inc<=90
        fprintf('The orbit is prograde.\n');
    else
        fprintf('The orbit is retrograde.\n');
    end
    
    % Right Ascention of ascending node
    OM = acosd(dot(I,n_vec)/n);
    if n_vec(2)<0
        OM=360-OM;
    end
    
    %argument of perigee
    om = 0;
    
    %argument of latitude (u)
    u_0 = acosd((dot(n_vec,R_vec)/(n*radius)));
    if R_vec(3)<0
        u_0 = 360-u_0;
    end
    
elseif e>0 && e<1
   
    n_vec = cross(K,h_vec);             % Vector n (nodal vector) pointing towards the ascending node
    n = sqrt(dot(n_vec,n_vec));                 %determinant of n
    
    %--------------------------------------------------------------------------
    %Obtaining Angles
    inc = acosd(dot(K,h_vec)/h);  % Inclination angle

    %including conditions to determine the quadrant of angles
    
    % Right Ascention of ascending node
    OM = acosd(dot(I,n_vec)/n);
    if n_vec(2)<0
        OM=360-OM;
    end
    
    % Argument of perigee
    om = acosd(dot(n_vec,e_vec)/(n*e));
    if e_vec(3)<0
        om=360-om;
    end
    
    % True anomaly
    anom = acosd(dot(e_vec,R_vec)/(r_0*e));
    if dot(R_vec,V_vec)<0
        anom=360-anom;
    end
    % Eccentric Anomaly (IN RAD)
    if abs(anom)>179 && abs(anom)<181 %for an angle close to 90, tan(90/2) is undefined, therefore we try using a rule involving cos instead
        E_00 = acos( (r_0*cosd(anom) + a*e)/a);
        
        if (anom>180 || anom<0) && E_00<anom %if the anomaly is in the third/fourth quadrant, eccentric anomaly should be higher
            E_0 = 2*pi - abs(E_00);
        else
            E_0 = E_00;
        end
        
    else
        E_0 = 2* atan2( sqrt((1-e)/(1+e))*tand(anom/2),1);
    end
    
end  
    