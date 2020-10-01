function [ Trajectory, F ] = nSegmentPropagator(X,varargin)
%   This function propagates and evaluates n_segment propagation results
%   The input (Varargin) is expected to be organized as:
%       varargin =      [   R0x R0y R0z V0x V0y V0z  ]
%   Each segment consists of two impulses, therefore we are able to know
%   the number of segments (n) by knowing that each impulse needs 7 free
%   variables organized as [dV1,FPA1,delta1,tof1,dV2,FPA2,delta2] --> X
%--------------------------------------------------------------------------
FVpS = 7;               %   Number of Free Variables per Segment
n  = length(X)/FVpS;    %   Number of segments
BCpS = 7;               %   Number of BCs per Segment
%   ode45 settings
OPTIONS = odeset('RelTol',1e-6,'AbsTol',1e-9);

%--------------------------------------------------------------------------
%                           First Impulse
%--------------------------------------------------------------------------
%   Initial Orbit R and V vectors
Init = varargin{:};

for i = 1 : n
    k = (i-1)*BCpS;     %   Skip the first (iteration number-1)*(BCpS) values
    h = (i-1)*FVpS;
    %   Initial condition for propagator taking into account impulse
    V0_ECI = VUW2I(X(k+1),X(k+2),X(k+3),Init);
    x1(1:3,1) = Init(1:3);
    x1(4:6,1) = V0_ECI;
    %   Final time for propagator (from input)
    tf1 = norm(X(h+4));
    %   Propagate the Orbit
%     [~,F1]  = ode45( @(t,xo) two_body(t,xo), [0,tf1],x1,OPTIONS);
    [~,F1]  = ode45( @(t,xo) two_body(t,xo), [0,tf1],x1);
    %   Extract the final R and V vectors
    Rf_1(:,1)    = F1(end,1:3);
    Vf_1(:,1)    = F1(end,4:6);
    Trajectory = F1(:,1:6);

%--------------------------------------------------------------------------
%                           Second Impulse
%--------------------------------------------------------------------------
    
    %   Initial condition for propagator taking into account impulse
    V2_ECI = VUW2I(X(k+5),X(k+6),X(k+7),F1(end,:));
    Rf_2 = Rf_1;
    Vf_2 = V2_ECI;
    
    %   Find all the constraints
    [Rmag,Vmag,energy,a,e,inc,T] = R_V_to_BCs(Rf_2,Vf_2);
    F(k+(1:7),1) = real([Rmag,Vmag,energy,a,e,inc,T])';
    Init = [Rf_2,Vf_2];
    

end