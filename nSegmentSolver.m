function [Rf,Vf,FreeVars] = nSegmentSolver(...
    Ro,Vo,BCs_logical,BCs_requ,constraints_index,constraints_val,...
    Guess_init,tol, perturb,output_results,varargin)
%   This code finds the Free Variables required given some initial
%   conditions using the Numerical Jacobian
%   Inputs
%   1-      Vo,Ro   :   Initial Position and  Velocity Vector
%   2-    BCs_logical :   Index of the Boundary Conditions: Vector of 7
%               logical [1/0] values in the following order --
%                         [ 1) R_mag,  ]
%                         [ 2) V_mag,  ]
%                         [ 3) energy, ]
%                         [ 4) a,      ]
%                         [ 5) e,      ]
%                         [ 6) i ,     ]
%                         [ 7) T       ]
%   3-    BCs_requ  :   The values of the BCs logical 1 in the same order
%   4-    constraints_index:   Logical (like 2) of Constraints:
%       [delta V, flight path angle, delta, Time of flight,dV2,FPA2,delta2]
%   5-   constraints_val:  Values of the constraints in order
%   6-   Guess_init :   Initial guess of free variables (vector of 4)
%   7-    tol       :   Tolerance acceptable in solution
%   8-    perturb   :   Relative Perturbation to give to find Jacobian
%--------------------------------------------------------------------------

%Construct initial input to Jacobian Constructor
Init = [Ro Vo]';
Guess(:,1) = Guess_init;        %   Initializing Guesses Matrix

%   Finding the indices of the constraints and the free variables
const_index = logical(constraints_index);
var_index = logical(~constraints_index);

%   Finding the indices of the BCs Required
BCs_index = logical(BCs_logical);

%   Forcing Constraints in Initial Guess Vector
Guess(const_index,1) = constraints_val;

Yd(:,1) = BCs_requ;                  %   Required Values for boundary conditions

err = 100;                      %   Initial error
delta_x(:,1) = Guess(:,1);      %   change in variable required

i = 1;
if  output_results == 1
    axes_handle = varargin{1};
    cla(axes_handle);
    draw_earth(axes_handle);
    
    %   draw the initial orbit
%       [dV1,FPA1,delta1,tof1,dV2,FPA2,delta2];
    [~,~,~,~,~,~,T] = R_V_to_BCs(Ro,Vo);
    X = [ 0 , 0  , 0 , T , 0 , 0 , 0 ];
    hold on;
    [r,~] = nSegmentPropagator(X,Init);
    plot_trajectory(r(:,1:3),axes_handle,'w',3,'none')
    FV_txt_handle = varargin{4};
    Guess_txt_handle = varargin{5};
    set(FV_txt_handle, 'string', 'Wait for what The Rock is cooking...');
    set(Guess_txt_handle, 'string', 'Wait for what The Rock is cooking...');
end
while err > tol
    
    [Trajectory,F_guess(:,i),Jacobian_Matrix] = Jacobian_Constructor(@nSegmentPropagator,...
        Guess(:,i), perturb,Init);
    
    Jacobian = Jacobian_Matrix(BCs_index,var_index);
    delta_x(var_index,i+1) = -pinv(Jacobian)*(F_guess(BCs_index,i)-Yd);
%     delta_x(var_index,i+1) = -Jacobian\(F_guess(BCs_index,i)-Yd);
    
    Guess(:,i+1) = Guess(:,i);
    
    Guess(var_index,i+1) = Guess(var_index,i) + delta_x(var_index,i+1); 
    
%     angles_ind = [2,3,6,7];
%     for k = 1 : length(angles_ind)
%        if Guess(angles_ind(k),i+1) > 2*pi
%           n_val = floor(Guess(angles_ind(k),i+1)/(2*pi));
%           Guess(angles_ind(k),i+1) = Guess(angles_ind(k),i+1) - n_val*2*pi;
%        end
%        if Guess(angles_ind(k),i+1) < 0
%           n_val = abs(floor(Guess(angles_ind(k),i+1)/(2*pi)));
%           Guess(angles_ind(k),i+1) = Guess(angles_ind(k),i+1) + n_val*2*pi;
%        end
%     end
    
%         err = norm((Yd-F_guess')./(Yd));
    err(i,1) = norm((Yd-F_guess(BCs_index,i)));
%     err = norm(((delta_x(var_index,i+1)-delta_x(var_index,i))./delta_x(var_index,i+1)));
%     err = norm(((delta_x(var_index,i+1)-delta_x(var_index,i))));
%     err = norm((delta_x(var_index,i+1)-delta_x(var_index,i))/delta_x(var_index,i));
    fprintf('Iteration Number %d, Error Value: %d\n',i,err(i));
    
    %   Call Plotting Function
    if output_results == 1
        axes_handle = varargin{1};
        Guess_table_handle = varargin{2};
        Res_table_handle = varargin{3};
        
        Current_Guess = Guess(:,1:i)';
        Results = [F_guess(:,1:i)',err(1:i)];
        color = rand(1,3);
        
        GUI_output_set(axes_handle,Trajectory(:,1:3),Guess_table_handle,Current_Guess,...
        Res_table_handle,Results,color,2,'h')
%         plot_trajectory(Position,axes_handle,color,3,'*');
    end
    
    
    i = i + 1;
end

%---------------------------
%   OUTPUT                  |
%---------------------------
FreeVars = Guess(:,end); %  |
Rf = Trajectory(end,1:3);%  |
Vf = Trajectory(end,4:6);%  |
%---------------------------

fprintf('The required [dV1,dGamma1,dDelta1,dV2,dGamma2,dDelta2,TOF] = \n [%d %d %d %d %d %d %d]\n',...  
FreeVars(1),FreeVars(2),FreeVars(3),FreeVars(5),FreeVars(6),FreeVars(7),FreeVars(4));
if output_results == 1
    FV_txt_handle = varargin{4};
    set(FV_txt_handle, 'string', ...
        sprintf('The required [dV1,dGamma1,dDelta1,dV2,dGamma2,dDelta2,TOF] =  [%d, %d, %d, %d, %d, %d, %d]\n',...  
        FreeVars(1),FreeVars(2),FreeVars(3),FreeVars(5),FreeVars(6),FreeVars(7),FreeVars(4)));

    Guess_txt_handle = varargin{5};
    set(Guess_txt_handle, 'string', ...
        sprintf('The final [R,V,energy,a,e,inc,T,error] =  [%d, %d, %d, %d, %d, %d, %d]\n',...  
        F_guess(1:7),err(end,1)));
end
% if  output_results == 1
%     axes_handle = varargin{1};
%     cla(axes_handle);
%     draw_earth(axes_handle);
% %     
% %       draw the initial orbit
% %       [dV1,FPA1,delta1,tof1,dV2,FPA2,delta2];
%     [~,~,~,~,~,~,T] = R_V_to_BCs(Trajectory(end,1:3),Trajectory(end,4:6));
%     X = [ 0 , 0  , 0 , T , 0 , 0 , 0 ];
%     hold on;
%     [r,~] = nSegmentPropagator(X,Trajectory);
%     plot_trajectory(r(:,1:3),axes_handle,'c',3,'none')
% 
% end