function GUI_output_set(axes_handle,Position,Guess_table_handle,Current_Guess,...
        Res_table_handle,Results,varargin)


set(Guess_table_handle,'Data',Current_Guess);
set(Res_table_handle,'Data',Results);
%   Plot Trajectory
plot_trajectory(Position,axes_handle,varargin{:});