function [Trajectory,F,Jacobian_Matrix] = Jacobian_Constructor(Fhandle,X0,perturbation,varargin)
%   This function takes 'M' variables to
%   change and constructs an NxM Jacobian Matrix
%   This function also accepts the relative perturbation to give to all the
%   variables [perturbation]
%
%   varargin stands for all the extra arguments Fhandle requires without
%   change
%--------------------------------------------------------------------------

%   First Compute the function at the given values of X0
[Trajectory,F] = Fhandle(X0,varargin{:});

%   We now have F -- which includes the output to check the 
%   effect of change of the variables on [F1(X),F2(X)...]

%   Find the number of functions to create Jacobian with [N]
%   and number of variables to change [M]
%       Jacobian Matrix = [ dF1/dx1     dF1/dx2 ... dF1/dxm ]
%                         [ dF2/dx1     dF2/dx2 ... dF2/dxm ]
%                         [  ...          ...   ...     ... ]
%                         [ dFn/dx1     dFn/dx2 ... dFn/dxm ]

N = length(F);

M = length(X0);
%   Initialize Jacobian Matrix
Jacobian_Matrix = zeros(N,M);

%   Get the perturbations for each variables
[a,b] = size(X0);
deltas = max(perturbation.*abs(X0),perturbation.*ones(a,b));

for i = 1 : M
    
    %   Perturb the suitable variable
    Xn = X0;
    Xn(i) = Xn(i) + deltas(i);
    
    %   Output of the function after perturbation
    [~,F2] = Fhandle(Xn,varargin{:});

    %   Add the difference in function to the Jacobian matrix
    Jacobian_Matrix(:,i) = (F2 - F)./deltas(i);
    
    
end